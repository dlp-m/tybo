# frozen_string_literal: true

def create_translations
  %w[en fr].each do |locale|
    locale_file = "config/locales/bo.#{locale}.yml"
    unless File.exist?(locale_file)
      File.write(locale_file, {
        locale => {
          'bo' => {
            'filters' => find_existing_translation('filters', locale),
            'details' => find_existing_translation('details', locale),
            'to' => find_existing_translation('to', locale),
            'confirm_delete' => find_existing_translation('confirm_delete', locale),
            'record' => {
            'created' => find_existing_translation('created', locale),
            'updated' => find_existing_translation('updated', locale),
            'destroyed' => find_existing_translation('destroyed', locale),
            'show' => find_existing_translation('show', locale),
          },
          'nav' => {
            'prev' => find_existing_translation('prev', locale),
            'next' => find_existing_translation('next', locale),
            'gap' => find_existing_translation('gap', locale)
          },
          'devise' => {
            'password' => find_existing_translation('password', locale),
            'new' => find_existing_translation('new', locale),
            'forgot_password' => find_existing_translation('forgot_password', locale),
          }
         }
        }
      }.to_yaml)
    end

    yaml_string = File.open locale_file
    data = YAML.load yaml_string
    data[locale]['bo'][file_name.underscore] = {
      'one' => find_existing_translation(bo_model.to_s.downcase, locale),
      'others' => find_existing_translation(bo_model.to_s.pluralize.downcase, locale),
      'new' => find_existing_translation(nil, locale),
      'subtitle' => find_existing_translation("list of #{bo_model.to_s.pluralize.downcase}", locale),
      'attributes' => model_attributes(data, locale)

    }
    output = YAML.dump data
    File.write(locale_file, output)
  end
end

def model_attributes(data, locale)
  hash = data.dig(locale, 'bo', file_name.underscore, 'attributes') || {}
  model_columns.each do |col|
    hash[col.to_s] ||= find_existing_translation(col, locale)
  end
  hash
end

def find_existing_translation(col, locale)
  return col.to_s.humanize.capitalize if locale == 'en'

  json = JSON.parse(File.read("#{__dir__}/files/#{locale}.json"))
  json[col.to_s]
end
