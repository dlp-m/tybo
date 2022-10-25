# frozen_string_literal: true

module Tables
  class TheadComponent < ViewComponent::Base
    renders_many :ths, Tables::ThComponent
  end
end
