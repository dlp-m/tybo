# frozen_string_literal: true

class IndexHeaderComponent < ViewComponent::Base
  renders_one :add_button, IndexHeaderAddComponent
  renders_one :export_button, IndexHeaderExportComponent

  def initialize(title:, subtitle:)
    @title = title
    @subtitle = subtitle
  end
end
