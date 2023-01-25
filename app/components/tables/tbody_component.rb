# frozen_string_literal: true

module Tables
  class TbodyComponent < ViewComponent::Base
    renders_many :trs, Tables::TrComponent
  end
end
