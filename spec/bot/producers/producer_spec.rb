require "spec_helper"
require "bot"
require "moqueue"
require "byebug"

describe Marketplace::Bot::Producers::Producer do
  let(:producer) { Marketplace::Bot::Producers::Producer.instance }
  let(:producer_type) { producer.instance_variable_get(:@type) }
  let(:producer_start_date) { producer.instance_variable_get(:@start_date) }
  let(:producer_end_date) { producer.instance_variable_get(:@end_date) }
  let(:producer_page_number) { producer.instance_variable_get(:@page_number) }
  let(:producer_order_id) { producer.instance_variable_get(:@order_id) }

  let(:type_test) { "fz_44" }
  let(:start_date_test) { "03.04.2015" }
  let(:end_date_test) { "05.04.2015" }
  let(:page_number_test) { 6 }
  let(:start_price_test) { 0 }
  let(:end_price_test) { 1000 }
  let(:body_test) { "<html></html>" }
  let(:order_id_test) { "4677879435533" }

  context "fill_attr" do
    it "only type" do
      producer.fill_attr("fz_94")

      expect(producer_type).to eq("fz_94")
      expect(producer_start_date).to eq(Date.today.strftime('%d.%m.%Y'))
      expect(producer_end_date).to eq(Date.today.strftime('%d.%m.%Y'))
      expect(producer_page_number).to eq(1)
    end

    it "all parameters" do
      producer.fill_attr("fz_44", "03.04.2015", "05.04.2015", 5)

      expect(producer_type).to eq(type_test)
      expect(producer_start_date).to eq(start_date_test)
      expect(producer_end_date).to eq(end_date_test)
      expect(producer_page_number).to eq(page_number_test)
    end
  end

  context "create exchange" do

  end

  context "amqp tests" do
    overload_amqp
    let!(:mq) { MQ.new }
    let!(:topic) { mq.topic("common") }
    let!(:queue_load) { mq.queue("load") }
    let!(:queue_parse) { mq.queue("parse") }

    after(:each) do 
      # overload_amqp
      reset_broker
    end

    # queue_load.bind(topic, :key=> "#.load")
    # queue_parse.bind(topic, :key=> "#.parse")
    # producer.stub(:x).and_return(topic)

    it "load_list" do

      queue_load.bind(topic, :key=> "#.load")
      # topic.publish("eatin ur foodz", :key => "cats.inUrFridge")
      # producer.stub(:x).and_return(mock_exchange(:topic => "common"))
      producer.stub(:x).and_return(topic)

      producer.load_list(start_price_test, end_price_test)

      queue_load.subscribe do |msg| 
        expect(msg).to_not eq(nil)
        expect(msg[:type]).to eq(type_test)
        expect(msg[:start_date]).to eq(start_date_test)
        expect(msg[:end_date]).to eq(end_date_test)
        expect(msg[:page_number]).to eq(page_number_test)
        expect(msg[:start_price]).to eq(start_price_test)
        expect(msg[:end_price]).to eq(end_price_test)
      end
      queue_load.unsubscribe
      expect(queue_load.received_messages.count).to eq(1)
    end

    it "parse list" do

      queue_parse.bind(topic, :key=> "#.parse")
      producer.stub(:x).and_return(topic)

      producer.parse_list("body_test", 100, 500)

      queue_parse.subscribe do |msg|
        expect(msg).to_not eq(nil)
        expect(msg[:type]).to eq(type_test)
        expect(msg[:start_date]).to eq(start_date_test)
        expect(msg[:end_date]).to eq(end_date_test)
        expect(msg[:page_number]).to eq(page_number_test)
        expect(msg[:start_price]).to eq(100)
        expect(msg[:end_price]).to eq(500)
        expect(msg[:page]).to eq("body_test")
      end
      queue_parse.unsubscribe
      expect(queue_parse.received_messages.count).to eq(1)
    end

    it "load order" do

      queue_load.bind(topic, :key=> "#.load")
      producer.stub(:x).and_return(topic)

      producer.load_order(order_id_test)
      queue_load.subscribe do |msg| 
        expect(msg).to_not eq(nil)
        expect(msg[:type]).to eq(type_test)
        expect(msg[:order_id]).to eq(order_id_test)
      end
      queue_load.unsubscribe
      expect(queue_load.received_messages.count).to eq(1)
      expect(producer_order_id).to eq(order_id_test)
    end

    it "parse order" do

      queue_parse.bind(topic, :key=> "#.parse")
      producer.stub(:x).and_return(topic)

      producer.parse_order(body_test)

      queue_parse.subscribe do |msg|
        expect(msg).to_not eq(nil)
        expect(msg[:type]).to eq(type_test)
        expect(msg[:page]).to eq(body_test)
      end
      queue_parse.unsubscribe
      expect(queue_parse.received_messages.count).to eq(1)
    end
  end

  context "check_date" do
    it { expect(producer.send(:check_date, "04.09.2012")).to_not eq(false) }
    it { expect(producer.send(:check_date, "51.04.2031")).to eq(false) }
    it { expect(producer.check_date("111.04.2031")).to eq(false)}
  end
end
