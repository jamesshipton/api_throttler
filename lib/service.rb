module Service
  class << self
    def rate_limit_exceeded?(service)
      ApiThrottler::KvStore.kv_store.keys("#{service}_*").count >= ApiThrottler::Rate.limit[service]
    end

    def do_request(service)
      if rate_limit_exceeded? service
        fail "#{service} rate limit exceeded"
      else
        $stdout.puts "successful #{service} response"
      end
    end
  end

  module Facebook
    class << self
      def do_friend
        Service.do_request('facebook')
      end
    end
  end
end
