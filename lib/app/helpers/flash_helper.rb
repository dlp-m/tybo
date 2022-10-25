# frozen_string_literal: true

module FlashHelper
  # todo remove me and create a custom administrator authentification
	def current_user
		OpenStruct.new(email:  "michel@tymate.com")
	end

  def classes_for_flash(key)
    if %w[error alert].include?(key)
      'red'
    else
      'green'
    end
  end
end
