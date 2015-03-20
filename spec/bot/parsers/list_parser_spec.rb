require "spec_helper"
require "bot"
require "webmock/rspec"

describe Marketplace::Bot::Parsers::ListParser do
  let(:list_parser) { Marketplace::Bot::Parsers::ListParser.new }

  let(:start_date) { "04.09.2012" }
  let(:end_date) { "05.09.2012" }
  let(:page) {  }

  context "get_ids on one page" do
    before(:each) do
      WebMock.stub_request(:get, /.*zakupki\.gov\.ru.*/).to_return(:body => File.open(Rails.root + '../../spec/support/order_list_without_arrow.html'), :status => 200)
    end

    it "check size and elements of array" do
    	expect(list_parser.get_ids(start_date, end_date).count).to eq(10)
    	expect(list_parser.get_ids(start_date, end_date)).to include(
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

  context "get_ids on several pages" do
  	before(:each) do
      WebMock.stub_request(:get, /.*zakupki\.gov\.ru.*/).to_return(:body => File.open(Rails.root + '../../spec/support/order_list_with_arrow.html'), :status => 200)
    end

    it "check size and elements of array" do
    	expect(list_parser.get_ids(start_date, end_date).count).to eq(100)
    end
  end
end
