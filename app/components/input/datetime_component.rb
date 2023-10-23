# frozen_string_literal: true

module Input
  class DatetimeComponent < ViewComponent::Base
    def initialize(item:, field:, form:, disabled: false)
      @item = item
      @field = field
      @form = form
      @label = label
      @disabled = disabled
    end

    def label
      I18n.t("bo.#{@item.class.name.underscore}.attributes.#{@field}")
    end
  end
end
