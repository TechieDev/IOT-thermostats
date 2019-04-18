class Reading < ApplicationRecord
  belongs_to :thermostat

  validates :thermostat, :seq_number, :temperature, :humidity, :battery_charge, presence: true
  validates :temperature, :humidity, :battery_charge, numericality: true
  validates :seq_number, numericality: { greater_than_or_equal_to: 1 }
  validates :humidity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :battery_charge, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
end
