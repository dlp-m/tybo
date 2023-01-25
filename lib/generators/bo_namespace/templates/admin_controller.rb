# frozen_string_literal: true

class <%= class_name %>Controller < ApplicationController
  include Pagy::Backend
  layout '<%= class_name.underscore %>'
  before_action :authenticate_<%= class_name.underscore %>!
end
