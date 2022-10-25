# frozen_string_literal: true

module Forms
  class DeleteButtonComponent < ViewComponent::Base
    def initialize(path)
      @path = path
    end
  end
end
