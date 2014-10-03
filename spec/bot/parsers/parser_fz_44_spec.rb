require "spec_helper"
require "bot"

describe Marketplace::Bot::Parsers::ParserFz44 do
  let(:parser_44) { Marketplace::Bot::Parsers::ParserFz44.new }
  
  context "get_order_info" do

    let(:doc) do
      doc = Nokogiri::HTML(open(Rails.root + '../../spec/support/fz_44.html'))
    end


    it "parse main info about 44_fz" do
      parser_44.get_order_info(doc)
      
      expect(parser_44.instance_variable_get(:@order_json)[:remote_id]).to eq("0361200000314000087")
      expect(parser_44.instance_variable_get(:@order_json)[:name]).to eq('Капитальный ремонт фасада здания ГБОУ ДПО "Институт развития образования Сахалинской области"')
      expect(parser_44.instance_variable_get(:@order_json)[:type]).to eq('Электронный аукцион')
    end

    it "parse get_auth_organization" do
      parser_44.get_auth_organization(doc)

      expect(parser_44.instance_variable_get(:@auth_organization_json)[:full_name]).to eq("министерство образования Сахалинской области")
      expect(parser_44.instance_variable_get(:@auth_organization_json)[:post_address]).to eq("Российская Федерация, 693020, Сахалинская обл, Южно-Сахалинск г, Ленина, 156, -")
      expect(parser_44.instance_variable_get(:@auth_organization_json)[:address]).to eq("Российская Федерация, 693020, Сахалинская обл, Южно-Сахалинск г, Ленина, 156, -")

      expect(parser_44.instance_variable_get(:@contacts_json)).to include(
        :person => "Графенина Ольга Сергеевна",
        :phone => "8-4242-300283",
        :email => "reception@iroso.ru",
        :fax => "8-4242-722501",
      )

      # expect(parser_44.instance_variable_get(:@contacts_json)[:contacts]).to include(
      #   :person => "Графенина Ольга Сергеевна",
      #   :phone => "8-4242-300283",
      #   :email => "reception@iroso.ru",
      #   :fax => "8-4242-722501"
      # )
    end
  end
end
