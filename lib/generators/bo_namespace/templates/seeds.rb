# frozen_string_literal: true

if Rails.env.development?
  %w[dev@tymate.com admin@tymate.com].each do |email|
    <%= class_name %>.find_or_create_by(
      email:
    ).update!(password: 'password')
  end
end
