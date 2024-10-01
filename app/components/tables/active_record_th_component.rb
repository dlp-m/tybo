# frozen_string_literal: true

require 'ransack/helpers/form_helper'

module Tables
  class ActiveRecordThComponent < ViewComponent::Base
    include Ransack::Helpers::FormHelper

    def initialize(ransack_object: nil, column_name: nil)
      @column_name = column_name
      @q = ransack_object
      @label = label
    end

    def label
      return unless @column_name

      I18n.t("bo.#{@q.object.klass.to_s.underscore}.attributes.#{@column_name}")
    end
  end
end
