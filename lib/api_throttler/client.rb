module ApiThrottler
  class Client
    def initialize(service)
      self.service = service
      self.queue = Queue.new(service)
      process_requests
    end

    def add(method)
      queue.push method
    end

    private
    attr_accessor :service, :queue

    def process_requests
      Thread.new do
        while true
          process_request unless queue.rate_limit_exceeded?
        end
      end
    end

    def process_request
      request = queue.pop
      Service.const_get(service.capitalize).send(request[1])
    end
  end
end