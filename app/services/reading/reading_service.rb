class Reading::ReadingService
	include RedisQueryManager

	attr_accessor :reading

	def initialize(thermostat_id: nil, humidity: nil, temperature: nil, battery_charge: nil)
    @thermostat_id = thermostat_id

    @id, @seq_number = _get_data

    @thermostat = Thermostat::ThermostatService.new(@thermostat_id).save_obj

    @reading = Reading::ReadingObj.new(
      id: @id,
      seq_number: @seq_number,
      thermostat_id: thermostat_id,
      humidity: humidity,
      temperature: temperature,
      battery_charge: battery_charge
    )
  end

  def save_obj
    response = @reading.save_obj
    after_save_obj_tasks if response
    response
  end

  private

  def _get_data
  	@id = reading_id_redis_key
  	@seq_number = seq_number_redis_key(@thermostat_id)
    # Set Id and Seq Number 
    set_id if @id.blank?
    set_seq_number(@thermostat_id) if @seq_number.blank?
    # return id and seq number
    @id, @seq_number = increment_id_and_seq_number(@thermostat_id)
  end

  def after_save_obj_tasks
    key = @reading.redis_key
    after_save_thermostat_update_task
    ReadingWorker.perform_async(key)
  end

  def after_save_thermostat_update_task
    reading = @reading.reading_obj
    Thermostat::ThermostatService.new(thermostat_id: @thermostat_id).
      update(
        thermostat: @thermostat,
        battery_charge: reading.battery_charge,
        humidity: reading.humidity,
        temperature: reading.temperature,
        seq_number: reading.seq_number
      )
  end

end
