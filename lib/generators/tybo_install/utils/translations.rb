# frozen_string_literal: true

  def create_base_translation_files
    %w[en fr].each do |local|
      locale_file = "config/locales/bo.#{local}.yml"
      File.write(locale_file, {
        local => {
          'bo' => {
            'filters' => find_existing_translation('filters', local),
            'show' => find_existing_translation('show', local),
            'to' => find_existing_translation('to', local),
            'confirm_delete' => find_existing_translation('confirm_delete', local),
            'record' => {
            'created' => find_existing_translation('created', local),
            'updated' => find_existing_translation('updated', local),
            'destroyed' => find_existing_translation('destroyed', local),
          },
            'nav' => {
              'prev' => find_existing_translation('prev', local),
              'next' => find_existing_translation('next', local),
              'gap' => find_existing_translation('gap', local)
            },
            'devise' => {
              'password' => find_existing_translation('password', local),
              'forgot_password' => find_existing_translation('forgot_password', local),
              'reset_password_instructions' => find_existing_translation('reset_password_instructions', local),
              'remember_me' => find_existing_translation('remember_me', local),
              'sign_in' => find_existing_translation('sign_in', local),
              'send_me_reset_password_instructions' => find_existing_translation('send_me_reset_password_instructions', local),
              'save' => find_existing_translation('save', local),
              }
            }
          }
        }.to_yaml
        )
    end
  end

def find_existing_translation(col, local)
  json = JSON.parse(File.read("#{__dir__}/files/#{local}.json"))
  json[col.to_s]
end

