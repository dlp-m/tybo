# frozen_string_literal: true

module Icons
  class DragAndDropComponent < ViewComponent::Base
    def initialize(text_color: 'text-tybo-800')
      @text_color = text_color
    end
  end
end
