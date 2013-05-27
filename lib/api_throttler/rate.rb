module ApiThrottler
  module Rate
    class << self
      def limit
        {
          'facebook'   => 60,
          'soundcloud' => 20,
          'youtube'    => 1000
        }
      end

      def duration
        {
          'facebook'   => 60,
          'soundcloud' => 10,
          'youtube'    => 2000
        }
      end
    end
  end
end
