# frozen_string_literal: true
module Devise
  class FormComponent < ViewComponent::Base
    def initialize(title:)
      @title = title
    end
  end
end
