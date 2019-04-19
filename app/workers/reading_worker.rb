class ReadingWorker
	include Sidekiq::Worker
  include RedisQueryManager

	def perform(reading_redis_key)
    attrs = fetch_reading(reading_redis_key).symbolize_keys
    reading = Reading::ReadingObj.new(allowed_attributes(attrs))
    reading.reading_obj.save!
    clean_reading(reading_redis_key)
  end

  private

  def allowed_attributes(attrs)
  	parameters = %i[id thermostat_id seq_number temperature humidity battery_charge]
    attrs.slice(*parameters)
  end
end