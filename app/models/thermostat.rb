class Thermostat < ApplicationRecord
	has_many :readings
  validates :location, presence: true
  validates :household_token, presence: true, uniqueness: true

  def self.get_stats_data(thermostat_id)
  	thermostat = Thermostat.find_by(id: thermostat_id)
  	if !thermostat.blank?
  		data = thermostat.readings.pluck(Arel.sql('avg(temperature), avg(humidity), avg(battery_charge), min(temperature), min(humidity), min(battery_charge), max(temperature), max(humidity), max(battery_charge)')).first
  		avg_data, min_data, max_data = data[0..2], data[3..5], data[6..9]
    end
  end
end
