# frozen_string_literal: true
module Forms
  class HasOneFormComponent < ViewComponent::Base
    def initialize(title:)
      @title = title
    end
  end
end
