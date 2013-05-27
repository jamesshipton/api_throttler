require 'api_throttler'

describe 'Throttle usage to 3rd party APIs' do
  before(:each) do
    ApiThrottler::KvStore.kv_store.flushdb
  end

  context 'When the Facebook rate limit has not been exceeded' do
    it 'the response should be successful' do
      $stdout.should_receive(:puts).with('successful facebook response')
      ApiThrottler.get 'facebook/do_friend'
    end
  end

  context 'When the Facebook rate limit has been exceeded' do
    it 'the response should be successful' do
      $stdout.should_receive(:puts).with('successful facebook response')
      increase_api_calls_to_exceed_limit 'facebook'
      ApiThrottler.get 'facebook/do_friend'
      sleep 6
    end
  end

  context 'When the Soundcloud rate limit has not been exceeded' do
    it 'the response should be successful' do
      $stdout.should_receive(:puts).with('successful soundcloud response')
      ApiThrottler.get 'soundcloud/do_music'
    end
  end

  context 'When the Soundcloud rate limit has been exceeded' do
    it 'the response should be successful' do
      $stdout.should_receive(:puts).with('successful soundcloud response')
      increase_api_calls_to_exceed_limit 'soundcloud'
      ApiThrottler.get 'soundcloud/do_music'
      sleep 6
    end
  end

  def increase_api_calls_to_exceed_limit(service)
    ((ApiThrottler::Rate.limit[service]+1)).times do
      ApiThrottler::KvStore.kv_store.setex "#{service}_#{SecureRandom.uuid}", 3, true
    end
  end
end
