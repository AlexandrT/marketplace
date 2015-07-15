require "spec_helper"
require "bot"
require "moqueue"

describe Marketplace::Bot::Producers::Producer do
  let(:producer) { Marketplace::Bot::Producers::Producer.instance }
  
  let(:job_params) do
    $job_params = { :start_price => "0", :end_price => "2000000", :type => "fz_44" }
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

    it "send" do

      queue_load.bind(topic, key: "*.load")
      queue_parse.bind(topic, key: "*.parse")
      # topic.publish("eatin ur foodz", :key => "cats.inUrFridge")
      # producer.stub(:x).and_return(mock_exchange(:topic => "common"))
      producer.stub(:x).and_return(topic)

      producer.send_job(job_params) { "list.load" }

      queue_parse.subscribe do |msg| 
        expect(msg).to_not eq(nil)
        expect(msg).to be_a(String)
      end

      producer.send_job(job_params) { "list.parse" }

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
