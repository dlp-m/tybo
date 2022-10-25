# frozen_string_literal: true

module Forms
  class SubtitleComponent < ViewComponent::Base
    def initialize(subtitle)
      @subtitle = subtitle
    end
  end
end
