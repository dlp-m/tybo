# frozen_string_literal: true

class FormComponent < ViewComponent::Base
  renders_one :breadcrumb, Forms::BreadcrumbComponent
  renders_one :title, Forms::TitleComponent
  renders_one :delete_button, Forms::DeleteButtonComponent

  def initialize(item:, nav_bar: nil)
    @item = item
    @nav_bar = nav_bar
  end

  attr_reader :item
end
