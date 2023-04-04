# frozen_string_literal: true

module Input
  class FileComponent < ViewComponent::Base
    def initialize(item:, field:, form:, variant: nil)
      @item = item
      @field = field
      @form = form
      @label = label
      @variant = variant
      @picture = picture
      @object = object
    end

    def label
      I18n.t("bo.#{@item.class.name.downcase}.attributes.#{@field}")
    end

    def picture
      return object unless @variant

      object.variant(@variant)
    end

    def object
      @item.send(@field)
    end
  end
end
