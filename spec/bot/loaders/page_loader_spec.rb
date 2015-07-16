require "spec_helper"
require "bot"
require "webmock/rspec"

describe Marketplace::Bot::Loaders::PageLoader do
  let(:page_loader) { Marketplace::Bot::Loaders::PageLoader.new }
  
  let(:list_params_with_date) do
    $list_params_with_date = { :start_date => "16.07.2015", :end_date => "17.07.2015", :start_price => "0", :end_price => "2000000", :type => "fz_44" }
  end
  
  let(:list_params_without_date) do
    $list_params_without_date = { :start_price => "0", :end_price => "2000000", :type => "fz_44" }
  end

  context "format price" do
    it { expect(page_loader.format_price(100)).to eq("100") }
	  it { expect(page_loader.format_price(1000)).to eq("1+000") }
	  it { expect(page_loader.format_price(10000)).to eq("10+000") }
	  it { expect(page_loader.format_price(100000000)).to eq("100+000+000") }
  end

  context "load_list" do
  	it "load_list" do
      stub_request(:any, "http://zakupki.gov.ru").to_return(:status => 200, :body => "", :headers => {})   #to_return(:body => File.new('/tmp/response_body.txt'), :status => 200)

  	  page_loader.load_list(list_params_with_date)
  	end
  end
end