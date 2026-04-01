require 'devise'
require 'pagy'
require 'ransack'
require 'view_component'

module Tybo
  class Engine < ::Rails::Engine
    initializer "tybo.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
      end
    end

    # Devise
    config.to_prepare do
      Devise::ConfirmationsController.layout "devise_admin"
      Devise::OmniauthCallbacksController.layout "devise_admin"
      Devise::PasswordsController.layout "devise_admin"
      Devise::RegistrationsController.layout "devise_admin"
      Devise::SessionsController.layout "devise_admin"
      Devise::UnlocksController.layout "devise_admin"
    end
  end
end

