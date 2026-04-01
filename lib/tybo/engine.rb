require 'devise'
require 'pagy'
require 'ransack'
require 'view_component'

module Tybo
  class Engine < ::Rails::Engine
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

