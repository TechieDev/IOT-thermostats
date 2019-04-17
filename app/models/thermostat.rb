class Thermostat < ApplicationRecord
	has_many :readings
  validates :location, presence: true
  validates :household_token, presence: true, uniqueness: true
end
