require "spec_helper"
require "bot"

describe Marketplace::Bot::Parsers::ParserFz94 do
	let(:parser_94) { Marketplace::Bot::Parsers::ParserFz94.new }

	let(:order_json) { parser_94.instance_variable_get(:@order_json) }
	let(:contacts_json) { parser_94.instance_variable_get(:@contacts_json) }
	let(:auth_organization_json) { parser_94.instance_variable_get(:@auth_organization_json) }

	context "get_order_info" do

		let(:doc) do
      doc = Nokogiri::XML(open(Rails.root + '../../spec/support/fz_94.xml'))
    end

    let(:contact_info) do
    	contact_info = doc.xpath('//notification/contactInfo')
    end

    let(:lots_set) do
    	lots_set = doc.xpath('//notification/lots/lot')
    end

    it "parse main info about 94_fz" do
    	parser_94.get_order_info(doc)

    	expect(order_json[:remote_id]).to eq("0173200001413001511")
    	expect(order_json[:name]).to eq("Открытый конкурс на право заключения государственного контракта на выполнение  подрядных работ по строительству объекта: «Реконструкция Звенигородского путепровода», по адресу: район Хорошево-Мневники, СЗАО города Москвы, Хорошевский район САО города Москвы")
    	expect(order_json[:type]).to eq("Открытый конкурс")
  	end

  	it "get_contacts" do
  		parser_94.get_contacts(contact_info)

  		expect(contacts_json[:person]).to eq('служба "Одного окна"')
  		expect(contacts_json[:phone]).to eq("+8 (495) 9577500")
  		expect(contacts_json[:email]).to eq("mostender@mos.ru")
  		expect(contacts_json[:fax]).to eq("+8 (495) 9579992")

  		# expect(parser_94.instance_variable_get(:@auth_organization)[:contacts]).to include
  	end

  	it "get_auth_organization" do
  		parser_94.get_auth_organization(contact_info)

  		expect(auth_organization_json[:full_name]).to eq("Департамент города Москвы по конкурентной политике")
  		expect(auth_organization_json[:short_name]).to eq("Тендерный комитет")
  		expect(auth_organization_json[:inn]).to eq("7704515009")
  		expect(auth_organization_json[:kpp]).to eq("770101001")
  		expect(auth_organization_json[:address]).to eq("Российская Федерация, 105062, Москва, Макаренко, 4/1, -")
  		expect(auth_organization_json[:post_address]).to eq("Российская Федерация, 107045, г. Москва, Печатников пер. , д.12")
  		expect(auth_organization_json[:phone]).to eq("+8 (495) 9577500")
  		expect(auth_organization_json[:fax]).to eq("+8 (495) 9579992")
  		expect(auth_organization_json[:email]).to eq("mostender@mos.ru")
  	end

  	it "get_lots" do
  		# parser_94.get_lots(lots_set)

  		# expect(order_json[:lots]).to include()
  	end
  end
end