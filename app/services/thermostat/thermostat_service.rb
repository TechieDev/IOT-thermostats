class Thermostat::ThermostatService
	include RedisQueryManager

	def initialize(thermostat_id)
    @thermostat_id = thermostat_id
  end

  def save_obj
  	_thermostat_data_save
  end

  def update(thermostat:, battery_charge:, humidity:, temperature:, seq_number:)
    new_metrics = { battery_charge: battery_charge, humidity: humidity, temperature: temperature }
    current_stats = thermostat.symbolize_keys
    new_stats = Hash.new

    current_stats.each do |key, stats|
    	new_stats[key] = Hash.new
    	new_stats[key]['avg'] = _get_avg_value(key, stats, new_metrics, seq_number)
      new_stats[key]['min'] = _get_min_value(key, stats, new_metrics)
      new_stats[key]['max'] = _get_max_value(key, stats, new_metrics)
    end

    redis_key = thermostat_redis_key(@thermostat_id)
    set(redis_key, new_stats.to_json)
  end

  def fetch
    redis_key = thermostat_redis_key(@thermostat_id)
    obj = get(redis_key)

    obj || _thermostat_data_save
  end


  private

  def _thermostat_data_save
  	return {} unless @thermostat_id

    key = thermostat_redis_key(@thermostat_id)
    value = _get_thermostat_data
    set(key, value.to_json)

    value

  end

  def _get_thermostat_data
  	avg_data, min_data, max_data = Thermostat.get_stats_data(@thermostat_id)
  	data_hash = Hash.new

    if !avg_data.blank? && !min_data.blank? && !max_data.blank?
	  	[:temperature, :humidity, :battery_charge].each_with_index do |ele, index|
	  		data_hash[ele] = _get_stats_data(index, avg_data, min_data, max_data)
	  	end
	  end

    data_hash
  end

  def _get_stats_data(index, avg_data, min_data, max_data)
  	data = Hash.new
  	data['avg'] = avg_data[index]
  	data['min'] = min_data[index]
  	data['max'] = max_data[index]
  	data
  end

  def _get_avg_value(key, stats, new_metrics, count)
  	current_avg = stats['avg']
  	new_value = new_metrics[key]
    new_avg  = ((current_avg.to_f * (count.to_i - 1)) + new_value.to_f) / count.to_i
    new_avg.round(2)
  end

  def _get_min_value(key, stats, new_metrics)
    current_min = stats['min']
  	new_value = new_metrics[key]
    new_min  = !current_min.blank? ? (current_min < new_value ? current_min : new_value) : new_value
    new_min.round(2)
  end

  def _get_max_value(key, stats, new_metrics)
    current_max = stats['max']
  	new_value = new_metrics[key]
    new_max  = !current_max.blank? ? (current_max > new_value ? current_max : new_value) : new_value
    new_max.round(2)
  end
end