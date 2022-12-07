# frozen_string_literal: true

module Tables
  class TheadComponent < ViewComponent::Base
    renders_many :ths, Tables::ThComponent
    renders_many :active_record_ths, Tables::ActiveRecordThComponent
  end
end
