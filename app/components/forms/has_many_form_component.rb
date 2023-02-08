# frozen_string_literal: true
module Forms
  class HasManyFormComponent < ViewComponent::Base
    def initialize(title:, label:)
      @title = title
    end
  end
end
