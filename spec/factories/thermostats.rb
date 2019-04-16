FactoryBot.define do
  factory :thermostat do
    household_token { SecureRandom.uuid }
    location { Faker::Address.street_address }
  end
end
