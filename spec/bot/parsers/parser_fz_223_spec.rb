require "spec_helper"
require "bot"
require "nokogiri"

describe Marketplace::Bot::Parsers::ParserFz223 do
	let(:parser_223) { Marketplace::Bot::Parsers::ParserFz223.new }

	let(:order_json) { parser_223.instance_variable_get(:@order_json) }

	context "tests for parser_223" do
		
		let(:doc) do
      xml = Nokogiri::XML(open(Rails.root + '../../spec/support/fz_223.xml'))
			byebug
      doc = xml.xpath('.//ns2:body/ns2:item/ns2:purchaseNoticeEPData')
    end

	  it "get_order_info" do
		  parser_223.get_order_info(doc)

		  expect(order_json[:remote_id]).to eq("31401442598")
		  expect(order_json[:name]).to eq("Лекарственные средства")
		  expect(order_json[:type]).to eq("Закупка у единственного поставщика (исполнителя, подрядчика)")
		end
	end
end