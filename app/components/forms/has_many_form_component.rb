# frozen_string_literal: true
module Forms
  class HasManyFormComponent < ViewComponent::Base
    def initialize(title:)
      @title = title
    end
  end
end
