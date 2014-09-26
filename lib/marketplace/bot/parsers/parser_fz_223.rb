module Marketplace
  class Bot::Parsers::ParserFz223 < Bot::Parsers::OrderParserXml

    def fill_json(info_page)
      page = Nokogiri::HTML(clean_trash(info_page), nil, 'utf-8')

      xml = page.xpath('//div[@id="tabs-2"]')[0]

      get_order_info(xml_doc)

      auth_org_xml = xml.xpath('//ns2:customer/mainInfo')[0]
      get_auth_organization(auth_org_xml)

      lots_xml = xml.xpath('//ns2:lots/lot')[0]
      get_all_lots(lots_xml)

      # customer_xml = xml.xpath('//ns2:placer/mainInfo')[0]
      # get_customer(customer_xml)

      contacts_xml = xml.xpath('//ns2:contact')[0]
      get_contacts(contacts_xml)
    end

    def get_order_info(xml_doc)
      @order_json[:remote_id] = xml_doc.xpath('.//ns2:registrationNumber')
      @order_json[:name] = xml_doc.xpath('.//ns2:name')
      @order_json[:type] = xml_doc.xpath('.//ns2:purchaseCodeName')
    end

    def get_auth_organization(auth_org_xml)
      @auth_organization = Hash.from_xml(auth_org_xml)
      @order_json[:auth_organization] = @auth_organization
    end

    def get_all_lots(lots_set)

      # жсон с отдельным лотом. после наполнения сливаем его в массив лотов
      lot_json = Hash.new

      # хэш с пунктами, входящими в лот  (<lotItem>)
      lot_item = Hash.new

      # массив со всеми пунктами лота, сливается в lots для каждого отдельного лота
      lot_items = Array.new

      # массив со всеми лотами, который сливаем в @order_json
      lots = Array.new

      lots_set.each do |lot|
        lot_json[:name] = lot.xpath('.//lotData/subject')
        lot_json[:currency] = lot.xpath('.//lotData/currency/code')
        lot_json[:price] = lot.xpath('.//lotData/initialSum')

        delivery_xml = lot.xpath('.//deliveryPlace')
        lot_json[:delivery_place] = get_delivery_place(delivery_xml)
        
        lot_items_xml = lot.xpath('.//lotItem')
        lot_items_xml.each do |lot_item_xml|
          lot_item[:okdp] = lot_item_xml.xpath('.//okdp/code')
          lot_item[:okved] = lot_item_xml.xpath('.//okved/code')
          lot_item[:measure] = lot_item_xml.xpath('.//okei/name')
          lot_item[:count] = lot_item_xml.xpath('.//qty')

          lot_items << lot_item.dup
          lot_item.clear
        end

        lots << lot_json.dup
        lot_json.clear
      end

      @order_json[:lots] = lots
    end

    # def get_customer(customer_xml)
    #   customers = Array.new

    #   @customer_json = Hash.from_xml(customer_xml)
    #   customers << @customer_json

    #   @order_json[:customer] = customers
    # end

    def get_contacts(contacts_xml)
      @contacts_json[:person] = contacts_xml.xpath('.//lastName') + " " + contacts_xml.xpath('.//firstName') + " " + contacts_xml.xpath('.//middleName')
      @contacts_json[:phone] = contacts_xml.xpath('.//phone')
      @contacts_json[:email] = contacts_xml.xpath('.//email')
      @contacts_json[:fax] = contacts_xml.xpath('.//fax')

      @auth_organization[:contacts] = @contacts_json
    end

    def get_delivery_place(delivery_xml)
      delivery_place = Hash.new
      delivery_place = Hash.from_xml(delivery_xml)
    end

  end
end