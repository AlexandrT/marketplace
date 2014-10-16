require "spec_helper"
require "bot"
require "nokogiri"

describe Marketplace::Bot::Parsers::ParserFz223 do
	let(:parser_223) { Marketplace::Bot::Parsers::ParserFz223.new }
	let(:order_json) { parser_223.instance_variable_get(:@order_json) }
	let(:auth_organization_json) { parser_223.instance_variable_get(:@auth_organization_json) }
	let(:contacts_json) { parser_223.instance_variable_get(:@contacts_json) }
	let(:lot_json) { parser_223.instance_variable_get(:@lot_json) }

	context "tests for parser_223" do
		
		let(:doc) do
      xml = Nokogiri::XML(open(Rails.root + '../../spec/support/fz_223.xml'), nil, 'utf-8')
      doc = xml.xpath('//ns2:purchaseNoticeEP/ns2:body/ns2:item/ns2:purchaseNoticeEPData')[0]
    end

    let(:auth_org_xml) do
    	auth_org_xml = doc.xpath('.//ns2:customer/*')[0]
    end

    let(:contacts_xml) do
    	contacts_xml = doc.xpath('.//ns2:contact')[0]
    end

    let(:lot_xml) do
    	lot_xml = doc.xpath('.//ns2:lots/*')[0]
    end

    let(:delivery_place_xml) do
    	delivery_place_xml = lot_xml.xpath('.//ns2:deliveryPlace', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")
    end

    let(:lot_item_xml) do
    	lot_item_xml = lot_xml.xpath('.//ns2:lotItem', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0]
    end

	  it "get_order_info" do
		  parser_223.get_order_info(doc)

		  expect(order_json[:remote_id]).to eq("31401442598")
		  expect(order_json[:name]).to eq("Лекарственные средства")
		  expect(order_json[:type]).to eq("Закупка у единственного поставщика (исполнителя, подрядчика)")
		end

		it "get_auth_organization" do
			parser_223.get_auth_organization(auth_org_xml)

			expect(auth_organization_json).to include(
				:fullName => 'Областное государственное унитарное предприятие "Магаданфармация"',
				:shortName => 'ОГУП "Магаданфармация"',
				:inn => "4900000025",
				:kpp => "490901001",
				:ogrn => "1024900950491",
				:legalAddress => "685000, Магаданская, Магадан, 3-й Транспортный, дом 12",
				:postalAddress => "685000, Магаданская, Магадан, 3-й Транспортный, дом 12",
				:phone => "7-4132-607485",
				:fax => "7-4132-630187",
				:email => "magfarm@online.magadan.su",
				:okato => "44401000000"
			)

			expect(order_json[:auth_organization]).to eq(auth_organization_json)
		end

		it "get contacts" do
			parser_223.get_contacts(contacts_xml)

			expect(contacts_json).to include(
				:email => 'inna_korol@inbox.ru',
				:fax => '+8 (4132) 631417',
				:person => 'Король Инна Геннадиевна',
				:phone => '+8 (4132) 634253',
			)

			expect(auth_organization_json[:contacts]).to eq(contacts_json)
		end

		it "get_common_lot_info lots" do
			parser_223.get_common_lot_info(lot_xml)

			expect(lot_json[:name]).to eq("открытие невозобновляемой кредитной линии лимитом на 11 814 000,00 евро для целевого использования денежных средств.")
			expect(lot_json[:currency]).to eq("EUR")
			expect(lot_json[:price]).to eq("11814000.00")
		end

		it "get_delivery_place" do
			parser_223.get_delivery_place(delivery_place_xml)

			expect(lot_json[:delivery_place]).to include(
				:address => "г. Хабаровск, ул. Воронежское шоссе, д.159.",
				:region => "Хабаровский край",
				:state => "Дальневосточный федеральный округ",
			)
		end

		it "get_lot_item_info" do
			parser_223.get_lot_item_info(lot_item_xml)

			expect(order_json[:lots][0]).to include(
				:count => "1",
				:measure => "Штука",
				:okdp => "6512020",
				:okved => "65.22",
			)
		end
	end
end