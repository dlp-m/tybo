# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  renders_many :items, SidebarItemComponent
  renders_one :current_user_card, CurrentUserMiniCardComponent
end
