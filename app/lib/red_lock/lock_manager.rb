module RedLock
  module LockManager

    def lock(action:, object:, ttl:, &block )
    	@key  = _resource_key(action, object)
    	begin
    		reading_lock = redlock.lock!(@key, ttl) do
    			block.call
    		end
    	rescue Redlock::LockError
    		# execption
    	end
  	end


    private

    def _resource_key(action, object)
    	action.to_s + '_' + object.class.to_s.downcase + '_' + object.try(:id).to_s
    end

    def redlock
      @@redlock ||= ConnectionPool::Wrapper.new(size: 5, timeout: 5) do
        redis = Redlock::Client.new([ Rails.application.secrets.locker[:redis_uri] ])
        redis
      end
    end
  end
end