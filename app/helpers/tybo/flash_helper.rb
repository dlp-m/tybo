# frozen_string_literal: true
module Tybo
  module FlashHelper
    def classes_for_flash(key)
      if %w[error alert].include?(key)
        'bg-red-100 text-red-700'
      else
        'bg-green-50 text-green-700'
      end
    end
  end
end
