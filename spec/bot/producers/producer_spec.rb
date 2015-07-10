require "spec_helper"
require "bot"
require "moqueue"

describe Marketplace::Bot::Producers::Producer do
  let(:producer) { Marketplace::Bot::Producers::Producer.instance }
  
  let(:search_params) do
    $search_params = { :start_price => "0", :end_price => "2000000", :type => "fz_44" }
  end

  let(:type_test) { "fz_44" }
  let(:start_date_test) { "03.04.2015" }
  let(:end_date_test) { "05.04.2015" }
  let(:page_number_test) { 6 }
  let(:start_price_test) { 0 }
  let(:end_price_test) { 1000 }
  let(:body_test) { "<html></html>" }
  let(:order_id_test) { "4677879435533" }

  context "amqp tests" do
    overload_amqp
    let!(:mq) { MQ.new }
    let!(:topic) { mq.topic("common") }
    let!(:queue_load) { mq.queue("load") }
    let!(:queue_parse) { mq.queue("parse") }

    after(:each) do
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

      producer.load_list(search_params)

      queue_load.subscribe do |msg| 
        expect(msg).to_not eq(nil)
        # expect(msg[:type]).to eq(type_test)
        # expect(msg[:start_date]).to eq(start_date_test)
        # expect(msg[:end_date]).to eq(end_date_test)
        # expect(msg[:page_number]).to eq(page_number_test)
        # expect(msg[:start_price]).to eq(start_price_test)
        # expect(msg[:end_price]).to eq(end_price_test)
      end
      queue_load.unsubscribe
      expect(queue_load.received_messages.count).to eq(1)
    end

    # it "parse list" do

    #   queue_parse.bind(topic, :key=> "#.parse")
    #   producer.stub(:x).and_return(topic)

    #   producer.parse_list("body_test", 100, 500)

    #   queue_parse.subscribe do |msg|
    #     expect(msg).to_not eq(nil)
    #     expect(msg[:type]).to eq(type_test)
    #     expect(msg[:start_date]).to eq(start_date_test)
    #     expect(msg[:end_date]).to eq(end_date_test)
    #     expect(msg[:page_number]).to eq(page_number_test)
    #     expect(msg[:start_price]).to eq(100)
    #     expect(msg[:end_price]).to eq(500)
    #     expect(msg[:page]).to eq("body_test")
    #   end
    #   queue_parse.unsubscribe
    #   expect(queue_parse.received_messages.count).to eq(1)
    # end

    # it "load order" do

    #   queue_load.bind(topic, :key=> "#.load")
    #   producer.stub(:x).and_return(topic)

    #   producer.load_order(order_id_test)
    #   queue_load.subscribe do |msg| 
    #     expect(msg).to_not eq(nil)
    #     expect(msg[:type]).to eq(type_test)
    #     expect(msg[:order_id]).to eq(order_id_test)
    #   end
    #   queue_load.unsubscribe
    #   expect(queue_load.received_messages.count).to eq(1)
    #   expect(producer_order_id).to eq(order_id_test)
    # end

    # it "parse order" do

    #   queue_parse.bind(topic, :key=> "#.parse")
    #   producer.stub(:x).and_return(topic)

    #   producer.parse_order(body_test)

    #   queue_parse.subscribe do |msg|
    #     expect(msg).to_not eq(nil)
    #     expect(msg[:type]).to eq(type_test)
    #     expect(msg[:page]).to eq(body_test)
    #   end
    #   queue_parse.unsubscribe
    #   expect(queue_parse.received_messages.count).to eq(1)
    # end
  end

  context "check_date" do
    it { expect(producer.send(:check_date, "04.09.2012")).to_not eq(false) }
    it { expect(producer.send(:check_date, "51.04.2031")).to eq(false) }
    it { expect(producer.check_date("111.04.2031")).to eq(false)}
  end
end
