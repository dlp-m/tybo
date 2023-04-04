# frozen_string_literal: true
module Forms
  class SearchInputComponent < ViewComponent::Base
    def initialize(label:)
      @label = label
    end
  end
end
