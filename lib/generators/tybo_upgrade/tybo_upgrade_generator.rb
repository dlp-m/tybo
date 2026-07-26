# frozen_string_literal: true

class TyboUpgradeGenerator < Rails::Generators::Base
  # Reuse the install templates (application_tybo_admin.js, tybo_admin.tailwind.css)
  source_root File.expand_path("../tybo_install/templates", __dir__)

  TYBO_CONTROLLERS = %w[
    attachments_controller
    dropdown_controller
    flash_controller
    search_form_controller
    sidebar_controller
    ts/search_controller
    ts/select_controller
  ].freeze

  def upgrade_css
    say_status :upgrade, "CSS → tybo_admin.css", :blue

    unless File.exist?("app/assets/stylesheets/tybo_admin.tailwind.css")
      if File.exist?("app/assets/stylesheets/application.tailwind.css")
        FileUtils.cp("app/assets/stylesheets/application.tailwind.css",
                     "app/assets/stylesheets/tybo_admin.tailwind.css")
        say_status :info, "Copied application.tailwind.css → tybo_admin.tailwind.css", :green
      else
        template "tybo_admin.tailwind.css", "app/assets/stylesheets/tybo_admin.tailwind.css"
      end
    end

    unless File.read("config/puma.rb").include?("plugin :tybo")
      inject_into_file "config/puma.rb", before: /\z/ do
        "\nplugin :tybo if ENV.fetch(\"RAILS_ENV\", \"development\") == \"development\"\n"
      end
    end
  end

  def upgrade_layouts
    say_status :upgrade, "Admin layouts", :blue

    Dir.glob("app/views/layouts/*.html.erb").each do |layout|
      content = File.read(layout)
      next unless content.include?("tailwind") || content.include?("@tymate")

      # stylesheet : retire "application" + remplace "tailwind"
      gsub_file layout,
        /[ \t]*<%=[ \t]*stylesheet_link_tag[ \t]+"application"[^%]*%>\n/, ""
      gsub_file layout,
        /stylesheet_link_tag "tailwind"[^%]*%>/,
        'stylesheet_link_tag "tybo_admin", "data-turbo-track": "reload" %>'
      gsub_file layout,
        /, "inter-font"/, ""

      # importmap
      gsub_file layout,
        /javascript_importmap_tags(?!\s+"application_tybo_admin")/,
        'javascript_importmap_tags "application_tybo_admin"'
    end
  end

  def upgrade_importmap
    say_status :upgrade, "config/importmap.rb", :blue

    # Remove old pins
    gsub_file "config/importmap.rb",
      /.*pin "@tymate\/tybo_js".*\n/, ""
    gsub_file "config/importmap.rb",
      /.*pin "tom-select".*\n/, ""
    gsub_file "config/importmap.rb",
      /.*pin "@rails\/request\.js".*\n/, ""
    gsub_file "config/importmap.rb",
      /.*pin_all_from "app\/javascript\/tybo\/controllers".*\n/, ""
    gsub_file "config/importmap.rb",
      /.*pin "application_tybo_admin".*\n/, ""

    inject_into_file "config/importmap.rb", before: /\z/ do
      <<~RUBY

        pin "application_tybo_admin", to: "tybo/application_tybo_admin.js"
        pin_all_from "app/javascript/tybo/controllers", under: "tybo/controllers"
        pin "tom-select", to: "https://esm.sh/tom-select"
        pin "@rails/request.js", to: "https://esm.sh/@rails/request.js"
      RUBY
    end
  end

  def upgrade_javascript
    say_status :upgrade, "JavaScript entry point", :blue

    # Copy JS controllers from engine into the host app
    js_source = Tybo::Engine.root.join("app/assets/javascripts/tybo/controllers")
    js_dest   = "app/javascript/tybo/controllers"
    directory js_source.to_s, js_dest, force: false
    say_status :info, "Copied Tybo controllers to #{js_dest} (existing files kept)", :green

    # Create application_tybo_admin.js (entry point for admin)
    template "application_tybo_admin.js", "app/javascript/tybo/application_tybo_admin.js"

    # In index.js, comment out the tybo controller exports that are now
    # handled by application_tybo_admin.js — without deleting anything
    old_index = "app/javascript/tybo/controllers/index.js"
    if File.exist?(old_index)
      content = File.read(old_index, encoding: "UTF-8")
      TYBO_CONTROLLERS.each do |ctrl|
        basename = File.basename(ctrl)
        content = content.gsub(
          /^(export \{ default as \w+ \} from ".*#{Regexp.escape(basename)}.*")/,
          '// [tybo 0.7] registered in application_tybo_admin.js — \1'
        )
      end
      File.write(old_index, content, encoding: "UTF-8")
      say_status :info, "Commented out tybo exports in index.js", :yellow
    end

    # Comment out (not delete) old tybo registrations from application.js
    app_js = "app/javascript/controllers/application.js"
    if File.exist?(app_js)
      content = File.read(app_js, encoding: "UTF-8")
      if content.include?("@tymate/tybo_js")
        content = content.gsub(
          /^(import \{[^}]+\} from "@tymate\/tybo_js")/,
          '// [tybo 0.7] moved to application_tybo_admin.js — \1'
        )
        %w[dropdown flash search-form ts--search ts--select sidebar].each do |name|
          content = content.gsub(
            /^(application\.register\('#{Regexp.escape(name)}'.*)/,
            '// [tybo 0.7] moved to application_tybo_admin.js — \1'
          )
        end
        File.write(app_js, content, encoding: "UTF-8")
        say_status :info, "Commented out @tymate/tybo_js lines in application.js", :yellow
      end
    end
  end

  def upgrade_data_controllers
    say_status :upgrade, "Stimulus data-controller attributes", :blue

    views = Dir.glob("app/views/**/*.html.erb") + Dir.glob("app/components/**/*.html.erb")

    views.each do |file|
      content = File.read(file, encoding: "UTF-8")

      next unless content.match?(/
        data-controller="(sidebar|flash|dropdown|search-form|ts--|attachments)" |
        ->sidebar\# | ->flash\# | ->dropdown\# | ->search-form\# |
        ->ts--select\# | ->ts--search\# | ->attachments\# |
        data-sidebar-target | data-dropdown-target
      /x)

      {
        'data-controller="sidebar"'     => 'data-controller="tybo--sidebar"',
        'data-controller="flash"'       => 'data-controller="tybo--flash"',
        'data-controller="dropdown"'    => 'data-controller="tybo--dropdown"',
        'data-controller="search-form"' => 'data-controller="tybo--search-form"',
        'data-controller="ts--select"'  => 'data-controller="tybo--ts--select"',
        'data-controller="ts--search"'  => 'data-controller="tybo--ts--search"',
        'data-controller="attachments"' => 'data-controller="tybo--attachments"',
        'data-sidebar-target'           => 'data-tybo--sidebar-target',
        'data-dropdown-target'          => 'data-tybo--dropdown-target',
        '->sidebar#'                    => '->tybo--sidebar#',
        '->flash#'                      => '->tybo--flash#',
        '->dropdown#'                   => '->tybo--dropdown#',
        '->search-form#'                => '->tybo--search-form#',
        '->ts--select#'                 => '->tybo--ts--select#',
        '->ts--search#'                 => '->tybo--ts--search#',
        '->attachments#'                => '->tybo--attachments#',
        'search_form_target:'           => '"tybo--search-form-target":',
        "controller: 'ts--select'"      => "controller: 'tybo--ts--select'",
        'controller: "search-form"'     => 'controller: "tybo--search-form"'
      }.each { |from, to| content = content.gsub(from, to) }

      File.write(file, content, encoding: "UTF-8")
      say_status :gsub, file, :green
    end
  end

  def build_css
    say_status :upgrade, "Building tybo_admin.css", :blue
    rake "tybo:build_css"
  end

  def done
    say ""
    say "✓ Tybo upgraded to 0.7.x", :green
    say ""
    say "Files to review:", :yellow
    say "  app/javascript/tybo/controllers/ (controllers copied from engine)", :yellow
    say "  app/javascript/tybo/controllers/index.js (exports commented out)", :yellow
    say "  app/javascript/controllers/application.js (registrations commented out)", :yellow
    say ""
    say "Once reviewed, you can delete the commented lines safely."
  end
end
