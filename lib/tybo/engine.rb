require 'devise'
require 'simple_form'
require 'simple_form/tailwind'
require 'pagy'
require 'ransack'

module Tybo
  class Engine < ::Rails::Engine
    # isolate_namespace Tybo
    # Devise
    config.to_prepare do
      Devise::ConfirmationsController.layout "devise_admin"
      Devise::OmniauthCallbacksController.layout "devise_admin"
      Devise::PasswordsController.layout "devise_admin"
      Devise::RegistrationsController.layout "devise_admin"
      Devise::SessionsController.layout "devise_admin"
      Devise::UnlocksController.layout "devise_admin"
    end
    # Assets
    initializer "tybo.assets" do |app|
      app.config.assets.precompile += %w[tybo_manifest]
    end
  end
end

