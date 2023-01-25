# frozen_string_literal: true

class IndexHeaderAddComponent < ViewComponent::Base
  def initialize(path:)
    @path = path
  end
end
