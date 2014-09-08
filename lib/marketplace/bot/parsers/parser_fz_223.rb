module Marketplace
  class ParserFz223 < OrderParserXml

    def fill_json(info_page)
      page = Nokogiri::HTML(clean_trash(info_page), nil, 'utf-8')

      xml = page.xpath('//div[@id="tabs-2"]')[0]

      get_order_info(xml_doc)

      customer_xml = xml.xpath('//ns2:customer/mainInfo')[0]
      get_customer(customer_xml)

      lots_xml = xml.xpath('//ns2:lots/lot')[0]
      get_all_lots(lots_xml)

      organization_xml = xml.xpath('//ns2:placer/mainInfo')[0]
      get_organization(organization_xml)

      contacts_xml = xml.xpath('//ns2:contact')[0]
      get_contacts(contacts_xml)
    end

    def get_order_info(xml_doc)
      @order_json[:remote_id] = xml_doc.xpath('.//ns2:registrationNumber')
      @order_json[:name] = xml_doc.xpath('.//ns2:name')
      @order_json[:type] = xml_doc.xpath('.//ns2:purchaseCodeName')
    end

    def get_customer(customer_xml)
      @customer = Hash.from_xml(customer_xml)
      @order_json[:customer] = @customer
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

    def get_organization(organization_xml)
      @organization_json = Hash.from_xml(organization_xml)
      @order_json[:organization] = @organization_json
    end

    def get_contacts(contacts_xml)
      org.search('.//organization').each do |node|
        node.remove
      end
      @contacts_json = Hash.from_xml(contacts_xml)
      @order_json[:contacts] = @contacts_json
    end

    def get_delivery_place(delivery_xml)
      delivery_place = Hash.new
      delivery_place = Hash.from_xml(delivery_xml)
    end

  end
end