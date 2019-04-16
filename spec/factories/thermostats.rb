FactoryBot.define do
  factory :thermostat do |t|
    household_token { SecureRandom.uuid }
    location { Faker::Address.street_address }
  end
end
