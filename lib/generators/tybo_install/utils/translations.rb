# frozen_string_literal: true

  def create_base_translation_files
    %w[en fr].each do |locale|
      locale_file = "config/locales/bo.#{locale}.yml"
      File.write(locale_file, {
        local => {
          'bo' => {
            'filters' => find_existing_translation('filters', locale),
            'show' => find_existing_translation('show', locale),
            'to' => find_existing_translation('to', locale),
            'confirm_delete' => find_existing_translation('confirm_delete', locale),
            'record' => {
              'created' => find_existing_translation('created', locale),
              'updated' => find_existing_translation('updated', locale),
              'destroyed' => find_existing_translation('destroyed', locale),
          },
          'nav' => {
            'prev' => find_existing_translation('prev', locale),
            'next' => find_existing_translation('next', locale),
            'gap' => find_existing_translation('gap', locale)
          },
          'devise' => {
            'password' => find_existing_translation('password', locale),
            'forgot_password' => find_existing_translation('forgot_password', locale),
            'reset_password_instructions' => find_existing_translation('reset_password_instructions', locale),
            'remember_me' => find_existing_translation('remember_me', locale),
            'sign_in' => find_existing_translation('sign_in', locale),
            'send_me_reset_password_instructions' => find_existing_translation('send_me_reset_password_instructions', locale),
            'save' => find_existing_translation('save', locale),
            }
          }
        }
      }.to_yaml)
    end
  end

def find_existing_translation(col, locale)
  json = JSON.parse(File.read("#{__dir__}/files/#{locale}.json"))
  json[col.to_s]
end

