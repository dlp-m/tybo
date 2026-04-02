# frozen_string_literal: true

class TyboInstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  require_relative "./utils/translations.rb"

  def install_dependencies
    run './bin/bundle add tailwindcss-rails' unless Bundler.locked_gems.specs.any? { |gem| gem.name == 'tailwindcss-rails' }
    gem "tailwindcss-rails", "~> 3" unless Bundler.locked_gems.specs.any? { |gem| gem.name == 'tailwindcss-rails' }
    gem 'simple_form' unless Bundler.locked_gems.specs.any? { |gem| gem.name == 'simple_form' }
    gem 'simple_form-tailwind', '~> 0.1.1' unless Bundler.locked_gems.specs.any? { |gem| gem.name == 'simple_form-tailwind' }
    gem 'action_policy', '~> 0.7.5' unless Bundler.locked_gems.specs.any? { |gem| gem.name == 'actionpolicy' }
    run 'bundle install'
  end

  def create_configuration_files
    create_base_translation_files
    template 'tybo_admin.tailwind.css', File.join('app/assets/stylesheets/tybo_admin.tailwind.css')
    template 'tailwind.config.js', File.join('config/tailwind.config.js'), force: true
    template 'tom-select.css', File.join('app/assets/stylesheets/tom-select.css')
    template 'simple_form_tailwind.rb', File.join('config/initializers/simple_form_tailwind.rb')
    template 'tybo_config.rb', File.join('config/initializers/tybo.rb')
  end

  def pin_js_dependencies
    inject_into_file 'config/importmap.rb', before: /\z/ do
      <<~RUBY

        pin "tom-select", to: "https://esm.sh/tom-select"
        pin "@rails/request.js", to: "https://esm.sh/@rails/request.js"
      RUBY
    end
  end

  def setup_puma_plugin
    inject_into_file 'config/puma.rb', before: /\z/ do
      "\nplugin :tybo if ENV.fetch(\"RAILS_ENV\", \"development\") == \"development\"\n"
    end
  end

  def build_css
    rake "tybo:build_css"
  end

  def create_routes
    route "root to: 'tybo/login#home'"
    route "mount Tybo::Engine => \"/tybo\""
  end

  def install_administrators
    run 'rails g bo_namespace Administrator'
  end

  def copy_javascript_controllers
    js_source = Tybo::Engine.root.join("app/assets/javascripts/tybo/controllers")
    js_dest   = "app/javascript/tybo/controllers"

    directory js_source.to_s, js_dest
  end

  def add_javascript_controllers
    template 'application_tybo_admin.js', 'app/javascript/tybo/application_tybo_admin.js'

    inject_into_file 'config/importmap.rb', before: /\z/ do
      "\npin \"application_tybo_admin\", to: \"tybo/application_tybo_admin.js\"\n" \
      "pin_all_from \"app/javascript/tybo/controllers\", under: \"tybo/controllers\"\n"
    end
  end

  def add_ransack_attributes
    inject_into_file 'app/models/application_record.rb', after: "primary_abstract_class\n" do
      "def self.ransackable_attributes(_auth_object = nil)
        column_names + _ransackers.keys
    end\ndef self.ransackable_associations(_auth_object = nil)
        reflect_on_all_associations.map { |a| a.name.to_s }
      end\n"
    end
  end
end
