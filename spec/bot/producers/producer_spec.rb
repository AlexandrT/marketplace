require "spec_helper"
require "bot"
require "moqueue"
require "byebug"

describe Marketplace::Bot::Producers::Producer do
  let(:producer) { Marketplace::Bot::Producers::Producer.instance }
  let(:type) { producer.instance_variable_get(:@type) }
  let(:start_date) { producer.instance_variable_get(:@start_date) }
  let(:end_date) { producer.instance_variable_get(:@end_date) }
  let(:page_number) { producer.instance_variable_get(:@page_number) }

  let(:load_worker) { Marketplace::Bot::Workers::LoadWorker.new }
  let(:parse_worker) { Marketplace::Bot::Workers::ParseWorker.new }

  context "fill_attr" do
    it "only type" do
      producer.fill_attr("fz_94")

      expect(type).to eq("fz_94")
      expect(start_date).to eq(Date.today.strftime('%d.%m.%Y'))
      expect(end_date).to eq(Date.today.strftime('%d.%m.%Y'))
      expect(page_number).to eq(1)
    end

    it "all parameters" do
      producer.fill_attr("fz_44", "03.04.2015", "05.04.2015", 5)

      expect(type).to eq("fz_44")
      expect(start_date).to eq("03.04.2015")
      expect(end_date).to eq("05.04.2015")
      expect(page_number).to eq(6)
    end
  end

  context "create exchange" do

  end

  context "load list" do
    it "???" do
      overload_amqp
      reset_broker
      mq = MQ.new
      topic = mq.topic("common")
      queue = mq.queue("load")
      queue.bind(topic, :key=> "#.load")
      # producer.stub(:x).and_return(mock_exchange(:topic => "common"))
      producer.stub(:x).and_return(topic)

      producer.load_list(0, 1000)
      queue.subscribe do |header, msg| 
        puts [header.routing_key, msg]
      end
      queue.to eq(1).received_messages
      # byebug
      # topic.publish("eatin ur foodz", :key => "cats.inUrFridge")
    end
  end

  context "check_date" do
    it { expect(producer.send(:check_date, "04.09.2012")).to_not eq(false) }
    it { expect(producer.send(:check_date, "51.04.2031")).to eq(false) }
    it { expect(producer.check_date("111.04.2031")).to eq(false)}
  end
end
