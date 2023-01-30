
class TyboInstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install_dependencies
    gem 'tailwindcss-rails', '~> 2.0', '>= 2.0.21'
    gem 'simple_form', '~> 5.2'
    gem 'simple_form-tailwind', '~> 0.1.1'
    run 'bundle install'
    run "rails tailwindcss:install"
  end

  def create_configuration_files
    template 'application.tailwind.css', File.join('app/assets/stylesheets/application.tailwind.css'), force: true
    template 'tailwind.config.js', File.join('config/tailwind.config.js'), force: true
    template 'tom-select.css', File.join('app/assets/stylesheets/tom-select.css')
    template 'simple_form_tailwind.rb', File.join('config/initializers/simple_form_tailwind.rb')
  end

  def pin_js_dependencies
    run "./bin/importmap pin tom-select --download"
    run "./bin/importmap pin @tymate/tybo"
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
      "import { Dropdown, Flash, SearchForm, TsSearch, TsSelect } from \"@tymate/tybo\"\n"
    end

    inject_into_file 'app/javascript/controllers/application.js', before: "export { application }" do 
      "application.register('dropdown', Dropdown)\napplication.register('flash', Flash)\napplication.register('search-form', SearchForm)\napplication.register('ts--search', TsSearch)\napplication.register('ts--select', TsSelect)\n"
    end
  end
end

