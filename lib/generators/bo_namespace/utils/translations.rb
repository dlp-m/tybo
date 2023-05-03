# frozen_string_literal: true

def create_translations
  %w[en fr].each do |local|
    locale_file = "config/locales/bo.#{local}.yml"
    yaml_string = File.open locale_file
    data = YAML.load yaml_string
    if data[local]['bo']['devise']['sign_in_as']
      data[local]['bo']['devise']['sign_in_as'].merge!(
        {
          "#{singular_name}" => find_existing_translation("sign_in_as_#{singular_name.downcase}", local)
        }
      )
    else
     data[local]['bo']['devise'].merge!(
      'sign_in_as' => {
        "#{singular_name}" => find_existing_translation("sign_in_as_#{singular_name.downcase}", local)
      }
    )
    end

    output = YAML.dump data
    File.write(locale_file, output)
  end
end

def find_existing_translation(col, local)
  json = {
    sign_in_as_administrator:{
      fr: "Espace administrateur",
      en: "Namespace administrator"
    },
    sign_in_as_user: {
      fr: "Espace user",
      en: "Namespace user"
    }
  }
  json.dig(col.to_sym, local.to_sym)
end
