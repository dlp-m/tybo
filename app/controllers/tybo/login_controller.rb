# frozen_string_literal: true
class Tybo::LoginController < ::ApplicationController
  layout 'devise_admin'
  def home
    @resources = Devise.mappings.sort.map(&:first)
    render template: 'login/home'
  end
end
