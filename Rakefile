require_relative 'lib/api_throttler'

desc 'Process a random selection of API requests'
task :default do
  api_calls = %w(soundcloud/do_music facebook/do_friend youtube/do_video)
  while true do
    ApiThrottler.get api_calls.sample
    sleep rand/5
  end
end
