Ransack.configure do |config|
  config.add_predicate 'from_date',
                       arel_predicate: 'gteq',
                       formatter: proc { |v| v.beginning_of_day },
                       validator: proc { |v| v.present? },
                       type: :date

  config.add_predicate 'to_date',
                       arel_predicate: 'lteq',
                       formatter: proc { |v| v.end_of_day },
                       validator: proc { |v| v.present? },
                       type: :date

  config.custom_arrows = {
    default_arrow: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor" class="inline-block w-4 h-4 align-middle">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 15 12 18.75 15.75 15m-7.5-6L12 5.25 15.75 9" />
                    </svg>',
    up_arrow: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor" class="inline-block w-4 h-4 align-middle">
                <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 15.75 7.5-7.5 7.5 7.5" />
              </svg>',
    down_arrow: '<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1" stroke="currentColor" class="inline-block w-4 h-4 align-middle">
                  <path stroke-linecap="round" stroke-linejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
                </svg>'
  }
end
