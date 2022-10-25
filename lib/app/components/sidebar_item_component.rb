# frozen_string_literal: true

class SidebarItemComponent < ViewComponent::Base
  def initialize(path:, label:, icon: Icons::HomeComponent)
    @path = path
    @icon = icon
    @label = label
  end
end
