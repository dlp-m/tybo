# frozen_string_literal: true

class <%= class_name %>Controller < ApplicationController
  include Pagy::Backend
  layout '<%= class_name.underscore %>'
  before_action :authenticate_<%= class_name.underscore %>!
  authorize :user, through: :current_<%= class_name.underscore %>

  private

  def namespace
    @namespace ||= Bo::<%= class_name %>.pluralize
  end
end
