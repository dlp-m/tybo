# frozen_string_literal: true

module Tables
  class TableComponent < ViewComponent::Base
    renders_one :thead, Tables::TheadComponent
    renders_one :tbody, Tables::TbodyComponent
  end
end
