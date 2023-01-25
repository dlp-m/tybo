# frozen_string_literal: true

class CurrentUserMiniCardComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end
end
