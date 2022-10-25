# frozen_string_literal: true

class IndexHeaderComponent < ViewComponent::Base
  renders_one :add_button, IndexHeaderAddComponent

  def initialize(title:, subtitle:)
    @title = title
    @subtitle = subtitle
  end
end
