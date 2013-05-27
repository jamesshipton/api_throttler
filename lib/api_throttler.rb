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
