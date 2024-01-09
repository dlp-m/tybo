# frozen_string_literal: true

module Tag
  class CategoryComponent < ViewComponent::Base
    def initialize(label:, color: 'indigo')
      @label = label
      @color = color
    end
  end
end
