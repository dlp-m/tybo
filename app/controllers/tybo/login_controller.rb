# frozen_string_literal: true
class Tybo::LoginController < ::ApplicationController
  layout 'devise_admin'
  def home
    @resources = []
    render template: "login/home"
  end
end
