# frozen_string_literal: true

module Tables
  class ActiveRecordThComponent < ViewComponent::Base
    include Ransack::Helpers::FormHelper

    def initialize(column_name:, ransack_object: )
      @column_name = column_name
      @q = ransack_object
      @label = label
    end

    def label
      I18n.t("bo.#{@q.object.klass.to_s.underscore}.attributes.#{@column_name}")
    end
  end
end
