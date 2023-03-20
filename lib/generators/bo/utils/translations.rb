# frozen_string_literal: true

def create_translations
  %w[en fr].each do |local|
    locale_file = "config/locales/bo.#{local}.yml"
    unless File.exist?(locale_file)
      File.write(locale_file, {
        local => {
          'bo' => {
            'filters' => find_existing_translation('filters', local),
            'record' => {
            'created' => find_existing_translation('created', local),
            'updated' => find_existing_translation('updated', local),
            'destroyed' => find_existing_translation('destroyed', local)
          }
         }
        }
      }.to_yaml)
    end

    yaml_string = File.open locale_file
    data = YAML.load yaml_string
    data[local]['bo'][file_name.underscore] = {
      'one' => find_existing_translation(bo_model.to_s.downcase, local),
      'others' => find_existing_translation(bo_model.to_s.pluralize.downcase, local),
      'subtitle' => find_existing_translation("list of #{bo_model.to_s.pluralize.downcase}", local),
      'attributes' => model_attributes(data, local)
    }
    output = YAML.dump data
    File.write(locale_file, output)
  end
end

def model_attributes(data, local)
  hash = data.dig(local, 'bo', file_name.underscore, 'attributes') || {}
  model_columns.each do |col|
    hash[col.to_s] ||= find_existing_translation(col, local)
  end
  hash
end

def find_existing_translation(col, local)
  return col.to_s.humanize.downcase if local == 'en'

  json = JSON.parse(File.read("#{__dir__}/files/#{local}.json"))
  json[col.to_s]
end
