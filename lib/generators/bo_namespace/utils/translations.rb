# frozen_string_literal: true

def create_translations
  %w[en fr].each do |locale|
    locale_file = "config/locales/bo.#{locale}.yml"
    yaml_string = File.open locale_file
    data = YAML.load yaml_string
    if data[locale]['bo']['devise']['sign_in_as']
      data[locale]['bo']['devise']['sign_in_as'].merge!(
        {
          "#{singular_name}" => find_existing_translation("sign_in_as_#{singular_name.downcase}", locale)
        }
      )
    else
     data[locale]['bo']['devise'].merge!(
      'sign_in_as' => {
        "#{singular_name}" => find_existing_translation("sign_in_as_#{singular_name.downcase}", locale)
      }
    )
    end

    output = YAML.dump data
    File.write(locale_file, output)
  end
end

def find_existing_translation(col, locael)
  json = {
    sign_in_as_administrator:{
      fr: "Espace administrateur",
      en: "Namespace administrator"
    },
    sign_in_as_user: {
      fr: "Espace utilisateur",
      en: "Namespace user"
    }
  }
  json.dig(col.to_sym, locale.to_sym)
end
