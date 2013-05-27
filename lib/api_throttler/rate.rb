module ApiThrottler
  module Rate
    class << self
      def limit
        {
          'facebook'   => 60
        }
      end

      def duration
        {
          'facebook'   => 60
        }
      end
    end
  end
end
