# frozen_string_literal: true

module Input
  class DatetimeComponent < ViewComponent::Base
    def initialize(item:, field:, form:)
      @item = item
      @field = field
      @form = form
      @label = label
    end

    def label
      I18n.t("bo.#{@item.class.name.underscore}.attributes.#{@field}")
    end
  end
end
