require_relative 'service'
require_relative 'api_throttler/client'
require_relative 'api_throttler/queue'
require_relative 'api_throttler/kv_store'

module ApiThrottler
  class << self
    def get(api_call)
      %r((?<service>\w+)/(?<request>\w+)) =~ api_call

      client(service).add request
      sleep 0.01
    end

    private
    def client(service)
      client_store.fetch(service) do
        Client.new(service)
      end
    end

    def client_store
      @client_store ||= {}
    end
  end
end
