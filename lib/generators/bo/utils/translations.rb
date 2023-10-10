# frozen_string_literal: true

def create_translations
  %w[en fr].each do |locale|
    locale_file = "config/locales/bo.#{locale}.yml"
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
