# frozen_string_literal: true

module Tables
  class TrComponent < ViewComponent::Base
    renders_many :tds, Tables::TdComponent

    def initialize(index: 0)
      @bg_color = 'bg-gray-50' if index.odd?
    end
  end
end
