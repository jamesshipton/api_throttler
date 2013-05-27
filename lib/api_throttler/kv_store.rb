require 'redis'

module ApiThrottler
  module KvStore
    class << self
      def kv_store
        @kv_store ||= Redis.new :db => 9
      end
    end
  end
end
