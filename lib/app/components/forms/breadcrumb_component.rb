# frozen_string_literal: true

module Forms
  class BreadcrumbComponent < ViewComponent::Base
    def initialize(items)
      @items = items
    end
  end
end
