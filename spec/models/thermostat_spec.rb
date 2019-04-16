require 'rails_helper'

RSpec.describe Thermostat, type: :model do
   it { should validate_presence_of(:household_token) }
   it { should validate_presence_of(:location) }
   it { should validate_uniqueness_of(:household_token)}
   
   it "saves thermostat" do
  	thermostat = Thermostat.new(household_token: SecureRandom.uuid, location: "Indra Nagar, Bangalore")
  	thermostat.save
  	expect(Thermostat.first).to eq(thermostat)
   end
end
