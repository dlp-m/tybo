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
end
