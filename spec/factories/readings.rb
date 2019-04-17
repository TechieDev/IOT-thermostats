FactoryBot.define do
  factory :reading do
    seq_number { Faker::Number.decimal_part(2) }
    temperature { Faker::Number.decimal(2) }
    humidity { Faker::Number.between(0, 100) }
    battery_charge { Faker::Number.between(0, 100) }
  end
end
