class Reading::ReadingObj
  include RedisQueryManager

  attr_reader :reading_obj, :redis_key

  def initialize(args = {})
    @redis_key = reading_redis_key(args[:id])
    @reading_obj = Reading.new(
      id: args[:id],
      seq_number: args[:seq_number],
      thermostat_id: args[:thermostat_id],
      humidity: args[:humidity],
      temperature: args[:temperature],
      battery_charge: args[:battery_charge]
    )
  end

  def save_obj
    return false unless @reading_obj.valid?

    value = @reading_obj.to_json
    set(@redis_key, value) == 'OK'
  end


  def find_obj
    reading = fetch_reading(@redis_key)
    reading || ::Reading.find(@reading_obj.id)
  end
end
