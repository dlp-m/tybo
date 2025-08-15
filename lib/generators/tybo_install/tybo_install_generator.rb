# frozen_string_literal: true

class TyboInstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  require_relative "./utils/translations.rb"

  def install_dependencies
    run './bin/bundle add tailwindcss-rails' unless Bundler.locked_gems.specs.any? { |gem| gem.name == 'tailwindcss-rails' }
    gem 'simple_form' unless Bundler.locked_gems.specs.any? { |gem| gem.name == 'simple_form' }
    gem 'simple_form-tailwind', '>= 0.1.1' unless Bundler.locked_gems.specs.any? { |gem| gem.name == 'simple_form-tailwind' }
    run 'bundle install'
    run "rails tailwindcss:install"
  end

  def create_configuration_files
    create_base_translation_files
    template 'application.tailwind.css', File.join('app/assets/stylesheets/application.tailwind.css'), force: true
    template 'tailwind.config.js', File.join('config/tailwind.config.js'), force: true
    template 'tom-select.css', File.join('app/assets/stylesheets/tom-select.css')
    template 'simple_form_tailwind.rb', File.join('config/initializers/simple_form_tailwind.rb')
    template 'tybo_config.rb', File.join('config/initializers/tybo.rb')
  end

  def pin_js_dependencies
    run "./bin/importmap pin tom-select --download"
    run "./bin/importmap pin @tymate/tybo_js"
  end

  def create_routes
    route "root to: 'tybo/login#home'"
    route "mount Tybo::Engine => \"/tybo\""
  end

  def install_administrators
    run 'rails g bo_namespace Administrator'
  end

  def add_javascript_controllers
    inject_into_file 'app/javascript/controllers/application.js', after: "const application = Application.start()\n" do 
      "import { Dropdown, Flash, SearchForm, TsSearch, TsSelect, Sidebar } from \"@tymate/tybo_js\"\n"
    end

    inject_into_file 'app/javascript/controllers/application.js', before: "export { application }" do 
      "application.register('dropdown', Dropdown)\napplication.register('flash', Flash)\napplication.register('search-form', SearchForm)\napplication.register('ts--search', TsSearch)\napplication.register('ts--select', TsSelect)\napplication.register('sidebar', Sidebar)\n"
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
