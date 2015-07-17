require "spec_helper"
require "bot"
require "nokogiri"

describe Marketplace::Bot::Parsers::ListParser do
  let(:list_parser) { Marketplace::Bot::Parsers::ListParser.new }
  let(:producer) { Marketplace::Bot::Producers::Producer.instance }

  let(:start_price) { 0 }
  let(:end_price) { 1000 }

  context "get_count" do
    let(:page_without_arrow) { Nokogiri::HTML(File.open(Rails.root + '../../spec/support/order_list_without_arrow.html'), nil, 'utf-8') }

    it { expect(list_parser.get_count(page_without_arrow)).to be_a(Fixnum) }
    it { expect(list_parser.get_count(page_without_arrow)).to eq(70) }
    it { expect { list_parser.get_count(0) }.not_to raise_error }
  end

  context "get_ids from page with more than 1000" do
    let(:page_more_1000) { File.open(Rails.root + '../../spec/support/order_list_more_1000.html') }

    let(:list_params) do
      $list_params = { :start_price => start_price, :end_price => end_price, :page => page_more_1000 }
    end

    overload_amqp
    let!(:mq) { MQ.new }
    let!(:topic) { mq.topic("common") }
    let!(:queue_load) { mq.queue("load") }
    let!(:queue_parse) { mq.queue("parse") }

    after(:each) do
      reset_broker
    end

    #before do
    #  producer.should_receive(:load_list).exactly(2).and_return(:producer)
    #end

    it "check size and elements of array" do
      queue_load.bind(topic, key: "*.load")
      queue_parse.bind(topic, key: "*.parse")
      producer.stub(:x).and_return(topic)

      list_parser.get_ids(list_params)
    end
  end

  context "get_ids from page without arrow" do 
    let(:page_without_arrow) { File.open(Rails.root + '../../spec/support/order_list_without_arrow.html') }

    let(:list_params) do
      $list_params = { :start_price => start_price, :end_price => end_price, :page => page_without_arrow }
    end

    #before do
    #  producer.should_receive(:load_order).exactly(10).and_return(:producer)
    #end

    it "check call method" do 

      expect(list_parser.get_ids(list_params)).to include(
        "/epz/order/notice/printForm/view.html?regNumber=0320100036714000024",
        "/epz/order/notice/printForm/view.html?regNumber=0122100000314000068",
        "/epz/order/notice/printForm/view.html?regNumber=0361200014514000011",
        "/epz/order/notice/printForm/view.html?regNumber=0316100017314000063",
        "/epz/order/notice/printForm/view.html?regNumber=0391100015114000089",
        "/epz/order/notice/printForm/view.html?regNumber=0334100029514000027",
        "/epz/order/notice/printForm/view.html?regNumber=0161200003114000061",
        "/epz/order/notice/printForm/view.html?regNumber=0339100001514000284",
        "/epz/order/notice/printForm/view.html?regNumber=0339100001514000283",
        "/epz/order/notice/printForm/view.html?regNumber=0339100001514000282"
      )
    end
  end

  context "get_ids from page with arrow" do
    let(:page_with_arrow) { File.open(Rails.root + '../../spec/support/order_list_with_arrow.html') }

    before do
      producer.should_receive(:load_list).and_return(:producer)
    end

    xit "check call methods" do
      expect(list_parser.get_ids(page_with_arrow, start_price, end_price)).to eq(:producer)
    end
  end
end
