module Marketplace
  class ParserFz94 < OrderParserXml
    def fill_json(info_page)
      info_page = Nokogiri::XML(info_page)

      get_order_info(info_page)

      contacts_xml = info_page.xpath('//notification/contactInfo')
      get_auth_organization(contacts_xml)
      get_contacts(contacts_xml)

      lots_set = info_page.xpath('//notification/lots/lot')
      get_lots(lots_set)
    end

    def get_order_info(info_page)
      @order_json[:remote_id] = info_page.xpath('//notification/notificationNumber')
      @order_json[:type] = info_page.xpath('//notification/placingWay/name')
      @order_json[:name] = info_page.xpath('//notification/orderName')
    end

    def get_contacts(contacts_xml)
      @contacts[:person] = contacts_xml.xpath('.//contactPerson/firstName') + " " + contacts_xml.xpath('.//contactPerson/middleName') + " " + contacts_xml.xpath('.//contactPerson/lastName')
      @contacts[:phone] = contacts_xml.xpath('.//contactPhone')
      @contacts[:email] = contacts_xml.xpath('.//cantactEMail')
      @contacts[:fax] = contacts_xml.xpath('.//contactFax')

      @auth_organization[:contacts] = @contacts
    end

    def get_auth_organization(contacts_xml)
      @auth_organization[:full_name] = contacts_xml.xpath('.//orgName')
      @auth_organization[:short_name] = contacts_xml.xpath('.//orgShortName')
      @auth_organization[:inn] = contacts_xml.xpath('.//orgInn')
      @auth_organization[:kpp] = contacts_xml.xpath('.//orgKpp')
      # @auth_organization[:ogrn]
      @auth_organization[:address] = contacts_xml.xpath('.//orgFactAddress')
      @auth_organization[:post_address] = contacts_xml.xpath('.//orgPostAddress')
      @auth_organization[:phone] = contacts_xml.xpath('.//contactPhone')
      @auth_organization[:fax] = contacts_xml.xpath('.//contactFax')
      @auth_organization[:email] = contacts_xml.xpath('.//contactEMail')
      # @auth_organization[:okato]
    end

    def get_lots(lots_set)
      # жсон с отдельным лотом. после наполнения сливаем его в массив лотов
      lot_json = Hash.new

      # хэш с пунктами, входящими в лот  (<lotItem>)
      lot_item = Hash.new

      # массив со всеми пунктами лота, сливается в lots для каждого отдельного лота
      lot_items = Array.new

      # массив со всеми лотами, который сливаем в @order_json
      lots = Array.new

      lots_set.each do |lot|
        lot_json[:name] = lot.xpath('.//lot/subject')
        lot_json[:currency] = lot.xpath('.//lot/currency/code')
        lot_json[:price] = lot.xpath('.//lot/maxPrice')
        
        lot_items_xml = lot.xpath('.//lot/customerRequirements/customerRequirement')
        lot_items_xml.each do |lot_item_xml|
          # lot_item[:okdp] = lot_item_xml.xpath('.//okdp/code')
          # lot_item[:okved] = lot_item_xml.xpath('.//okved/code')
          # lot_item[:measure] = lot_item_xml.xpath('.//okei/name')
          # lot_item[:count] = lot_item_xml.xpath('.//qty')

          lot_item[:delivery_place] = lot_item.xpath('.//deliveryPlace')

          lot_items << lot_item.dup
          lot_item.clear
        end

        lots << lot_json.dup
        lot_json.clear
      end

      @order_json[:lots] = lots
    end
  end
end