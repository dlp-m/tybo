# frozen_string_literal: true

class SignOutButtonComponent < ViewComponent::Base
  def initialize(resource:)
    @resource = resource
  end
end
