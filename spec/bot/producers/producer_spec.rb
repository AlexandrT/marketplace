require "spec_helper"
require "bot"
require "moqueue"
require "byebug"

describe Marketplace::Bot::Producers::Producer do
  let(:producer) { Marketplace::Bot::Producers::Producer.instance }
  let(:type) { producer.instance_variable_get(:@type) }

  let(:load_worker) { Marketplace::Bot::Workers::LoadWorker.new }
  let(:parse_worker) { Marketplace::Bot::Workers::ParseWorker.new }


  # context "test rabbit" do
    
  #   before(:each) do
  #    overload_amqp
  #    reset_broker
  #    mq = MQ.new
  #    x = mock_exchange(:topic => "common")
  #    queue = mq.queue("load")
  #    queue.bind(x, :key => "#.load")

  #    producer.stub(:create){ mock_exchange(:topic => "common") }
  #   end

  #   it "load_list" do 
  #     byebug
  #     producer.load_list(0, 30000)
  #     byebug
  #     mq = MQ.new
  #     x = mock_exchange(:topic => "common")
  #     queue = mq.queue("load")
  #     queue.bind(x, :key => "#.load")
  #     queue.subscribe do |message| 
  #       byebug
  #     end
  #   end
  # end

  context "fill_attr" do
    it "only type" do
      producer.fill_attr("fz_94")

      expect(type).to eq("fz_94")
    end
  end

  context "check_date" do
    it { expect(producer.send(:check_date, "04.09.2012")).to_not eq(false) }
    it { expect(producer.send(:check_date, "51.04.2031")).to eq(false) }
    it { expect(producer.check_date("111.04.2031")).to eq(false)}
  end
end
