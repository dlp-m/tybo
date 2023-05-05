# frozen_string_literal: true
module Tybo
  module FlashHelper
    def classes_for_flash(key)
      if %w[error alert].include?(key)
        'bg-red-alert text-white'
      else
        'bg-tybo text-white'
      end
    end
  end
end
