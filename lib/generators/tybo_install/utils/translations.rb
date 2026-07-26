# frozen_string_literal: true

  FR_DATE_TRANSLATIONS = {
    'date' => {
      'abbr_day_names'   => %w[Dim Lun Mar Mer Jeu Ven Sam],
      'day_names'        => %w[Dimanche Lundi Mardi Mercredi Jeudi Vendredi Samedi],
      'abbr_month_names' => [nil, 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'],
      'month_names'      => [nil, 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
      'formats'          => { 'default' => '%d/%m/%Y', 'short' => '%e %b', 'long' => '%e %B %Y' }
    },
    'time' => {
      'am'      => 'am',
      'pm'      => 'pm',
      'formats' => { 'default' => '%A %d %B %Y %H:%M:%S %z', 'short' => '%d %b %H:%M', 'long' => '%A %d %B %Y %H:%M' }
    },
    'datetime' => {
      'distance_in_words' => {
        'half_a_minute'      => 'une demi-minute',
        'less_than_x_seconds' => { 'one' => "moins d'une seconde", 'other' => 'moins de %{count} secondes' },
        'x_seconds'          => { 'one' => '1 seconde', 'other' => '%{count} secondes' },
        'less_than_x_minutes' => { 'one' => "moins d'une minute", 'other' => 'moins de %{count} minutes' },
        'x_minutes'          => { 'one' => '1 minute', 'other' => '%{count} minutes' },
        'about_x_hours'      => { 'one' => 'environ 1 heure', 'other' => 'environ %{count} heures' },
        'x_days'             => { 'one' => '1 jour', 'other' => '%{count} jours' },
        'about_x_months'     => { 'one' => 'environ 1 mois', 'other' => 'environ %{count} mois' },
        'x_months'           => { 'one' => '1 mois', 'other' => '%{count} mois' },
        'about_x_years'      => { 'one' => 'environ 1 an', 'other' => 'environ %{count} ans' },
        'over_x_years'       => { 'one' => "plus d'un an", 'other' => 'plus de %{count} ans' },
        'almost_x_years'     => { 'one' => 'presque 1 an', 'other' => 'presque %{count} ans' }
      }
    }
  }.freeze

  def create_base_translation_files
    %w[en fr].each do |locale|
      locale_file = "config/locales/bo.#{locale}.yml"
      extra = locale == 'fr' ? FR_DATE_TRANSLATIONS : {}
      File.write(locale_file, {
        locale => extra.merge({
          'bo' => {
            'filters' => find_existing_translation('filters', locale),
            'show' => find_existing_translation('show', locale),
            'to' => find_existing_translation('to', locale),
            'export_btn' => find_existing_translation('export_btn', locale),
            'add_ressource_btn' => find_existing_translation('add_ressource_btn', locale),
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
          'pagy' => {
            'showing' =>  find_existing_translation('showing', locale),
            'to' =>  find_existing_translation('to', locale),
            'of' =>  find_existing_translation('of', locale),
            'show' =>  find_existing_translation('show', locale),
            'results' =>  find_existing_translation('results', locale)
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
        })
      }.to_yaml)
    end
  end

def find_existing_translation(col, locale)
  json = JSON.parse(File.read("#{__dir__}/files/#{locale}.json"))
  json[col.to_s]
end

