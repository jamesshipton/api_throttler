module ApiThrottler
  class Queue
    def initialize(service)
      self.service = service
      self.kv_store = ApiThrottler::KvStore.kv_store
    end

    def rate_limit_exceeded?
      kv_store.keys("#{service}_*").count >= rate_limit
    end

    def push(request)
      kv_store.rpush service, request
    end

    def pop
      kv_store.multi do
        kv_store.setex "#{service}_#{SecureRandom.uuid}", rate_duration, true
        kv_store.lpop service
      end
    end

    private
    attr_accessor :kv_store, :service

    def rate_limit
      @rate_limit ||= ApiThrottler::Rate.limit[service]
    end

    def rate_duration
      @rate_duration ||= ApiThrottler::Rate.duration[service]
    end
  end
end