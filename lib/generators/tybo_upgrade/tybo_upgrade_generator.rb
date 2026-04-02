# frozen_string_literal: true

class TyboUpgradeGenerator < Rails::Generators::Base
  # Reuse the install templates (application_tybo_admin.js, tybo_admin.tailwind.css)
  source_root File.expand_path("../tybo_install/templates", __dir__)

  def upgrade_css
    say_status :upgrade, "CSS → tybo_admin.css", :blue

    unless File.exist?("app/assets/stylesheets/tybo_admin.tailwind.css")
      if File.exist?("app/assets/stylesheets/application.tailwind.css")
        copy_file "app/assets/stylesheets/application.tailwind.css",
                  "app/assets/stylesheets/tybo_admin.tailwind.css"
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

      # stylesheet
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

      # hotwire_livereload
      gsub_file layout,
        /[ \t]*<%=[ \t]*hotwire_livereload_tags[^%]*%>\n/, ""
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

    # Create application_tybo_admin.js
    template "application_tybo_admin.js", "app/javascript/tybo/application_tybo_admin.js"

    # Mark old index.js as removable (replaced by application_tybo_admin.js)
    old_index = "app/javascript/tybo/controllers/index.js"
    if File.exist?(old_index)
      FileUtils.mv(old_index, "app/javascript/tybo/controllers/index.remove_me.js")
      say_status :info,
        "Renamed index.js → index.remove_me.js (no longer needed, review and delete)", :yellow
    end

    # Clean old tybo registrations from application.js
    app_js = "app/javascript/controllers/application.js"
    if File.exist?(app_js) && File.read(app_js).include?("@tymate/tybo_js")
      gsub_file app_js, /^import \{[^}]+\} from "@tymate\/tybo_js"\n/, ""
      gsub_file app_js, /^application\.register\('dropdown'.*\n/, ""
      gsub_file app_js, /^application\.register\('flash'.*\n/, ""
      gsub_file app_js, /^application\.register\('search-form'.*\n/, ""
      gsub_file app_js, /^application\.register\('ts--search'.*\n/, ""
      gsub_file app_js, /^application\.register\('ts--select'.*\n/, ""
      gsub_file app_js, /^application\.register\('sidebar'.*\n/, ""
      say_status :info, "Removed @tymate/tybo_js registrations from application.js", :green
    end
  end

  def upgrade_data_controllers
    say_status :upgrade, "Stimulus data-controller attributes", :blue

    views = Dir.glob("app/views/**/*.html.erb") + Dir.glob("app/components/**/*.html.erb")

    views.each do |file|
      content = File.read(file)

      # Skip files that don't reference old controller names
      next unless content.match?(/
        data-controller="(sidebar|flash|dropdown|search-form|ts--|attachments)" |
        ->sidebar\# | ->flash\# | ->dropdown\# | ->search-form\# |
        ->ts--select\# | ->ts--search\# | ->attachments\# |
        data-sidebar-target | data-dropdown-target
      /x)

      # data-controller
      gsub_file file, 'data-controller="sidebar"',     'data-controller="tybo--sidebar"'
      gsub_file file, 'data-controller="flash"',       'data-controller="tybo--flash"'
      gsub_file file, 'data-controller="dropdown"',    'data-controller="tybo--dropdown"'
      gsub_file file, 'data-controller="search-form"', 'data-controller="tybo--search-form"'
      gsub_file file, 'data-controller="ts--select"',  'data-controller="tybo--ts--select"'
      gsub_file file, 'data-controller="ts--search"',  'data-controller="tybo--ts--search"'
      gsub_file file, 'data-controller="attachments"', 'data-controller="tybo--attachments"'

      # targets
      gsub_file file, 'data-sidebar-target',  'data-tybo--sidebar-target'
      gsub_file file, 'data-dropdown-target', 'data-tybo--dropdown-target'

      # actions
      gsub_file file, '->sidebar#',     '->tybo--sidebar#'
      gsub_file file, '->flash#',       '->tybo--flash#'
      gsub_file file, '->dropdown#',    '->tybo--dropdown#'
      gsub_file file, '->search-form#', '->tybo--search-form#'
      gsub_file file, '->ts--select#',  '->tybo--ts--select#'
      gsub_file file, '->ts--search#',  '->tybo--ts--search#'
      gsub_file file, '->attachments#', '->tybo--attachments#'

      # Ruby data hash actions (search_form_target → "tybo--search-form-target")
      gsub_file file, 'search_form_target:',  '"tybo--search-form-target":'
      gsub_file file, "controller: 'ts--select'", "controller: 'tybo--ts--select'"
      gsub_file file, 'controller: "search-form"', 'controller: "tybo--search-form"'
    end
  end

  def upgrade_translations
    say_status :upgrade, "Translations", :blue

    %w[en fr].each do |locale|
      file = "config/locales/bo.#{locale}.yml"
      next unless File.exist?(file)
      next if File.read(file).include?("add_ressource_btn")

      gsub_file file, /(\s+export_btn:.+)/ do |match|
        value = locale == "fr" ? '"+"' : '"+"'
        "#{match}\n  add_ressource_btn: #{value}"
      end
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
    say "Files to review and delete:", :yellow
    say "  app/javascript/tybo/controllers/index.remove_me.js", :yellow
    say ""
    say "Next steps:"
    say "  1. Review *.remove_me.js files and delete them"
    say "  2. Run your test suite"
  end
end
