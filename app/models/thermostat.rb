class Thermostat < ApplicationRecord
	validates :location, presence: true
  validates :household_token, presence: true, uniqueness: true
end
