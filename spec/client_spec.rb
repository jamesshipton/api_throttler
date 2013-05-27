require 'api_throttler'

describe 'Client' do
  let(:service) { 'facebook' }
  let(:method)  { 'do_something' }
  let(:queue)   { double 'queue', :add => true }

  subject { ApiThrottler::Client.new service }

  describe '.new' do
    it 'create a new queue' do
      ApiThrottler::Queue.should_receive(:new).with(service).and_return(queue)
      subject
    end
  end

  describe '#add' do
    it 'pushes a request onto the queue' do
      ApiThrottler::Queue.stub(:new => queue)
      queue.should_receive(:push).with(method)
      subject.add method
    end
  end
end
