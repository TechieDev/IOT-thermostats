module RedisQueryManager
  def set(key, value)
    connection.with do |conn|
      conn.set key, value
    end
  end

  def get(key)
    connection.with do |conn|
      conn.get key
    end
  end

  def mget(keys)
    connection.with do |conn|
      conn.mget(*keys)
    end
  end

  def del(key)
    connection.with do |conn|
      conn.del(key)
    end
  end

  def reading_redis_key(id)
    "reading_#{id}"
  end

  def seq_number_redis_key(thermostat_id)
    "seq_number_#{thermostat_id}"
  end

  def thermostat_redis_key(thermostat_id)
    "thermostat_#{thermostat_id}"
  end

  def reading_id_redis_key
    'reading_id'
  end

  def increment_id_and_seq_number(thermostat_id)
    connection.with do |conn|
      conn.multi
      conn.incr reading_id_redis_key
      conn.incr seq_number_redis_key(thermostat_id)
      conn.exec
    end
  end

  def set_seq_number(thermostat_id)
    key = seq_number_redis_key(thermostat_id)
    value = ::Reading.where(thermostat_id: @hermostat_id).maximum(:seq_number).to_i
    set(key, value)
  end

  def set_id
    set(global_reading_id_redis_key, ::Reading.maximum(:id).to_i)
  end

  def fetch_reading(redis_key)
    reading = get redis_key
    return unless reading

    JSON.parse(reading)
  end

  def clean_reading(redis_key)
    del(redis_key)
  end


  private

  def connection
    @@connection ||= ConnectionPool::Wrapper.new(size: 5, timeout: 5) do
      redis = Redis.new(url: Rails.application.secrets.readings[:redis_uri])
      redis
    end
  end
end