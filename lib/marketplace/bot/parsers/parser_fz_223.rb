module Marketplace
  class Bot::Parsers::ParserFz223 < Bot::Parsers::Base

    def fill_json(info_page)
      page = Nokogiri::HTML(clean_trash(info_page), nil, 'utf-8')

      xml = page.xpath('//div[@id="tabs-2"]').first
      doc = xml.xpath('.//ns2:purchaseNoticeEP/ns2:body/ns2:item/ns2:purchaseNoticeEPData').first

      get_order_info(doc)

      auth_org_xml = doc.xpath('.//ns2:customer/mainInfo').first
      get_auth_organization(auth_org_xml)

      lots_xml = doc.xpath('.//ns2:lots').first
      get_all_lots(lots_xml)

      # customer_xml = doc.xpath('//ns2:placer/mainInfo').first
      # get_customer(customer_xml)

      contacts_xml = doc.xpath('.//ns2:contact').first
      get_contacts(contacts_xml)
    end

    def get_order_info(doc)
      @order_json[:remote_id] = doc.xpath('.//ns2:registrationNumber').first.text
      @order_json[:name] = doc.xpath('.//ns2:name').first.text
      @order_json[:type] = doc.xpath('.//ns2:purchaseCodeName').first.text
    end

    def get_auth_organization(auth_org_xml)
      @auth_organization_json[:fullName] = get_content(auth_org_xml, './/ns2:fullName')
      @auth_organization_json[:shortName] = get_content(auth_org_xml, './/ns2:shortName')
      @auth_organization_json[:inn] = get_content(auth_org_xml, './/ns2:inn')
      @auth_organization_json[:kpp] = get_content(auth_org_xml, './/ns2:kpp')
      @auth_organization_json[:ogrn] = get_content(auth_org_xml, './/ns2:ogrn')
      @auth_organization_json[:legalAddress] = get_content(auth_org_xml, './/ns2:legalAddress')
      @auth_organization_json[:postalAddress] = get_content(auth_org_xml, './/ns2:postalAddress')
      @auth_organization_json[:phone] = get_content(auth_org_xml, './/ns2:phone')
      @auth_organization_json[:fax] = get_content(auth_org_xml, './/ns2:fax')
      @auth_organization_json[:email] = get_content(auth_org_xml, './/ns2:email')
      @auth_organization_json[:okato] = get_content(auth_org_xml, './/ns2:okato')

      @order_json[:auth_organization] = @auth_organization_json
    end

    def get_all_lots(lots_xml)

      lots_set = lots_xml.xpath('.//ns2:lot', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")

      lots_set.each do |lot|
        get_common_lot_info(lot)

        delivery_xml = lot.xpath('.//ns2:lotData/ns2:deliveryPlace', 'ns2' => "http://zakupki.gov.ru/223fz/types/1").first
        get_delivery_place(delivery_xml)
        
        lot_items_xml = lot.xpath('.//ns2:lotItem', 'ns2' => "http://zakupki.gov.ru/223fz/types/1")
        lot_items_xml.each do |lot_item_xml|
          get_lot_item_info(lot_item_xml)
        end
      end
    end

    def get_common_lot_info(lot)
      @lot_json[:name] = get_content(lot, './/ns2:lotData/ns2:subject')
      @lot_json[:currency] = get_content(lot, './/ns2:lotData/ns2:currency/ns2:code')
      @lot_json[:price] = get_content(lot, './/ns2:lotData/ns2:initialSum')
    end

    def get_lot_item_info(lot_item_xml)
      # хэш с пунктами, входящими в лот  (<lotItem>)
      lot_item = Hash.new
      lot_item[:okdp] = get_content(lot_item_xml, './/ns2:okdp/ns2:code')
      lot_item[:okved] = get_content(lot_item_xml, './/ns2:okved/ns2:code')
      lot_item[:measure] = get_content(lot_item_xml, './/ns2:okei/ns2:name')
      lot_item[:count] = get_content(lot_item_xml, './/ns2:qty')

      @order_json[:lots] << lot_item
    end

    # def get_customer(customer_xml)
    #   customers = Array.new

    #   @customer_json = Hash.from_xml(customer_xml)
    #   customers << @customer_json

    #   @order_json[:customer] = customers
    # end

    def get_contacts(contacts_xml)
      @contacts_json[:person] = get_content(contacts_xml, './/ns2:lastName') + " " + get_content(contacts_xml, './/ns2:firstName') + " " + get_content(contacts_xml, './/ns2:middleName')
      @contacts_json[:phone] = get_content(contacts_xml, './/ns2:phone')
      @contacts_json[:email] = get_content(contacts_xml, './/ns2:email')
      @contacts_json[:fax] = get_content(contacts_xml, './/ns2:fax')

      @auth_organization_json[:contacts] = @contacts_json
    end

    def get_delivery_place(delivery_xml)
      delivery_place = Hash.new

      delivery_place[:state] = get_content(delivery_xml, './/ns2:state')
      delivery_place[:region] = get_content(delivery_xml, './/ns2:region')
      delivery_place[:address] = get_content(delivery_xml, './/ns2:address')
      @lot_json[:delivery_place] = delivery_place
    end

    def get_content(xml, xpath_str)
      xml.xpath(xpath_str, 'ns2' => "http://zakupki.gov.ru/223fz/types/1").first.text
    end

  end
end