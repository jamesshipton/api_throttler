require 'api_throttler'

describe 'Queue' do
  let(:service)     { 'facebook' }
  let(:kv_store)    { double 'kv_store' }
  let(:limit)       { 10 }
  let(:limit_hash)  { { service => limit } }
  let(:request) { double 'request' }

  subject { ApiThrottler::Queue.new(service) }

  before do
    ApiThrottler::KvStore.stub(:kv_store => kv_store)
    ApiThrottler::Rate.stub(:limit).and_return(limit_hash)
  end

  describe '.new' do
    it 'connects to the KVStore' do
      ApiThrottler::KvStore.should_receive(:kv_store)
      subject
    end
  end

  describe '#push' do
    it 'appends a request to the queue' do
      kv_store.should_receive(:rpush).with(service, request)
      subject.push request
    end
  end

  describe '#pop' do
    let(:uuid)          { 'uuid' }
    let(:duration)      { 10 }
    let(:duration_hash) { { service => duration } }

    before do
      SecureRandom.stub(:uuid => uuid)
      ApiThrottler::Rate.stub(:duration).and_return(duration_hash)
      kv_store.stub(:lpop => request)
      kv_store.stub(:setex)
      kv_store.stub(:multi).and_yield
    end

    it 'removes the first element from the queue' do
      kv_store.should_receive(:lpop).with(service)
      subject.pop
    end

    it 'sets a key with an expiry prepended with the service and appended with a uuid' do
      kv_store.should_receive(:setex).with("#{service}_#{uuid}", duration, true)
      subject.pop
    end

    it 'runs the commands in an atomic transaction' do
      kv_store.should_receive(:multi)
      subject.pop
    end

    it 'returns the popped request' do
      subject.pop.should == request
    end
  end

  describe '#rate_limit_exceeded?' do
    let(:keys_under_limit) { keys(limit-1) }
    let(:keys_on_limit)    { keys(limit) }
    let(:keys_over_limit)  { keys(limit+1) }

    it 'fetches the valid key from the kv_store' do
      kv_store.should_receive(:keys).with("#{service}_*").and_return(keys_under_limit)
      subject.rate_limit_exceeded?
    end

    it 'returns false if the recent requests are under the rate limit' do
      kv_store.stub(:keys => keys_under_limit)
      subject.rate_limit_exceeded?.should == false
    end

    it 'returns true if the recent requests are equal to the rate limit' do
      kv_store.stub(:keys => keys_on_limit)
      subject.rate_limit_exceeded?.should == true
    end

    it 'returns true if the recent requests are above the rate limit' do
      kv_store.stub(:keys => keys_over_limit)
      subject.rate_limit_exceeded?.should == true
    end

    def keys(number)
      (1..number).map { double 'key' }
    end
  end
end