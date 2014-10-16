module Marketplace
  class Bot::Parsers::ParserFz223 < Bot::Parsers::OrderParserXml

    def fill_json(info_page)
      page = Nokogiri::HTML(clean_trash(info_page), nil, 'utf-8')

      xml = page.xpath('//div[@id="tabs-2"]')[0]
      doc = xml.xpath('.//ns2:purchaseNoticeEP/ns2:body/ns2:item/ns2:purchaseNoticeEPData')[0]

      get_order_info(doc)

      auth_org_xml = doc.xpath('.//ns2:customer/mainInfo')[0]
      get_auth_organization(auth_org_xml)

      lots_xml = doc.xpath('.//ns2:lots')[0]
      get_all_lots(lots_xml)

      # customer_xml = doc.xpath('//ns2:placer/mainInfo')[0]
      # get_customer(customer_xml)

      contacts_xml = doc.xpath('.//ns2:contact')[0]
      get_contacts(contacts_xml)
    end

    def get_order_info(doc)
      @order_json[:remote_id] = doc.xpath('.//ns2:registrationNumber').text
      @order_json[:name] = doc.xpath('.//ns2:name').text
      @order_json[:type] = doc.xpath('.//ns2:purchaseCodeName').text
    end

    def get_auth_organization(auth_org_xml)
      # byebug
      @auth_organization_json[:fullName] = auth_org_xml.xpath('.//ns2:fullName', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:shortName] = auth_org_xml.xpath('.//ns2:shortName', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:inn] = auth_org_xml.xpath('.//ns2:inn', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:kpp] = auth_org_xml.xpath('.//ns2:kpp', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:ogrn] = auth_org_xml.xpath('.//ns2:ogrn', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:legalAddress] = auth_org_xml.xpath('.//ns2:legalAddress', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:postalAddress] = auth_org_xml.xpath('.//ns2:postalAddress', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:phone] = auth_org_xml.xpath('.//ns2:phone', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:fax] = auth_org_xml.xpath('.//ns2:fax', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:email] = auth_org_xml.xpath('.//ns2:email', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @auth_organization_json[:okato] = auth_org_xml.xpath('.//ns2:okato', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text

      @order_json[:auth_organization] = @auth_organization_json
    end

    def get_all_lots(lots_xml)

      lots_set = lots_xml.xpath('.//ns2:lot', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")

      lots_set.each do |lot|
        get_common_lot_info(lot)

        delivery_xml = lot.xpath('.//ns2:lotData/ns2:deliveryPlace', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")
        get_delivery_place(delivery_xml)
        
        lot_items_xml = lot.xpath('.//ns2:lotItem', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")
        lot_items_xml.each do |lot_item_xml|
          get_lot_item_info(lot_item_xml)
        end
      end
    end

    def get_common_lot_info(lot)
      @lot_json[:name] = lot.xpath('.//ns2:lotData/ns2:subject', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @lot_json[:currency] = lot.xpath('.//ns2:lotData/ns2:currency/ns2:code', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      @lot_json[:price] = lot.xpath('.//ns2:lotData/ns2:initialSum', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
    end

    def get_lot_item_info(lot_item_xml)
      # хэш с пунктами, входящими в лот  (<lotItem>)
      lot_item = Hash.new
      lot_item[:okdp] = lot_item_xml.xpath('.//ns2:okdp/ns2:code', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      lot_item[:okved] = lot_item_xml.xpath('.//ns2:okved/ns2:code', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      lot_item[:measure] = lot_item_xml.xpath('.//ns2:okei/ns2:name', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text
      lot_item[:count] = lot_item_xml.xpath('.//ns2:qty', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").text

      @order_json[:lots] << lot_item
    end

    # def get_customer(customer_xml)
    #   customers = Array.new

    #   @customer_json = Hash.from_xml(customer_xml)
    #   customers << @customer_json

    #   @order_json[:customer] = customers
    # end

    def get_contacts(contacts_xml)
      @contacts_json[:person] = contacts_xml.xpath('.//ns2:lastName', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text + " " + contacts_xml.xpath('.//ns2:firstName', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text + " " + contacts_xml.xpath('.//ns2:middleName', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text
      @contacts_json[:phone] = contacts_xml.xpath('.//ns2:phone', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text
      @contacts_json[:email] = contacts_xml.xpath('.//ns2:email', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text
      @contacts_json[:fax] = contacts_xml.xpath('.//ns2:fax', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text

      @auth_organization_json[:contacts] = @contacts_json
    end

    def get_delivery_place(delivery_xml)
      delivery_place = Hash.new

      delivery_place[:state] = delivery_xml.xpath('.//ns2:state', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text
      delivery_place[:region] = delivery_xml.xpath('.//ns2:region', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text
      delivery_place[:address] = delivery_xml.xpath('.//ns2:address', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")[0].text
      @lot_json[:delivery_place] = delivery_place
    end

  end
end