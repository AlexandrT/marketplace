require "spec_helper"
require "bot"
require "webmock/rspec"

describe Marketplace::Bot::Loaders::PageLoader do
	let(:page_loader) { Marketplace::Bot::Loaders::PageLoader.new }

	context "format price" do
		it { expect(page_loader.format_price(100)).to eq("100") }
		it { expect(page_loader.format_price(1000)).to eq("1+000") }
		it { expect(page_loader.format_price(10000)).to eq("10+000") }
		it { expect(page_loader.format_price(100000000)).to eq("100+000+000") }
	end
end