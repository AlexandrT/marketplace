module Marketplace
  class Bot::Parsers::ParserFz94 < Bot::Parsers::OrderParserXml
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
      @order_json[:remote_id] = info_page.xpath('//notification/notificationNumber').text
      @order_json[:type] = info_page.xpath('//notification/placingWay/name').text
      @order_json[:name] = info_page.xpath('//notification/orderName').text
    end

    def get_contacts(contacts_xml)
      @contacts_json[:person] = contacts_xml.xpath('.//contactPerson/lastName').text + " " + contacts_xml.xpath('.//contactPerson/firstName').text + " " + contacts_xml.xpath('.//contactPerson/middleName').text
      @contacts_json[:phone] = contacts_xml.xpath('.//contactPhone').text
      @contacts_json[:email] = contacts_xml.xpath('.//contactEMail').text
      @contacts_json[:fax] = contacts_xml.xpath('.//contactFax').text

      @auth_organization_json[:contacts] = @contacts_json
    end

    def get_auth_organization(contacts_xml)
      @auth_organization_json[:full_name] = contacts_xml.xpath('.//orgName').text
      @auth_organization_json[:short_name] = contacts_xml.xpath('.//orgShortName').text
      @auth_organization_json[:inn] = contacts_xml.xpath('.//orgInn').text
      @auth_organization_json[:kpp] = contacts_xml.xpath('.//orgKpp').text
      # @auth_organization_json[:ogrn]
      @auth_organization_json[:address] = contacts_xml.xpath('.//orgFactAddress').text
      @auth_organization_json[:post_address] = contacts_xml.xpath('.//orgPostAddress').text
      @auth_organization_json[:phone] = contacts_xml.xpath('.//contactPhone').text
      @auth_organization_json[:fax] = contacts_xml.xpath('.//contactFax').text
      @auth_organization_json[:email] = contacts_xml.xpath('.//contactEMail').text
      # @auth_organization_json[:okato]
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
        lot_json[:name] = lot.xpath('.//subject').text
        lot_json[:currency] = lot.xpath('.//currency/code').text
        lot_json[:price] = lot.xpath('.//maxPrice').text
        
        customer_xml = lot.xpath('.//customerRequirements/customerRequirement/organization')
        get_customer(customer_xml)

        lot_json[:customer] = @customer

        lot_items_xml = lot.xpath('.//customerRequirements/customerRequirement').text
        lot_items_xml.each do |lot_item_xml|
          lot_item[:okdp] = lot_item_xml.xpath('.//products/product/code').text
          # lot_item[:okved] = lot_item_xml.xpath('.//okved/code').text
          # lot_item[:measure] = lot_item_xml.xpath('.//okei/name').text
          lot_item[:count] = lot_item_xml.xpath('.//quantity').text

          lot_item[:delivery_place] = lot_item.xpath('.//deliveryPlace').text

          lot_items << lot_item.dup
          lot_item.clear
        end

        lots << lot_json.dup
        lot_json.clear
      end

      @order_json[:lots] = lots
    end

    def get_customer(customer_xml)
      @customer[:name] = customer_xml.xpath('.//fullName').text
      # @customer[:bik] = 
      # @customer[:ls_number] = 
      # @customer[:rs_number] = 
      @customer[:real_address] = customer_xml.xpath('.//factualAddress/addressLine').text
      @customer[:post_address] = customer_xml.xpath('.//postalAddress').text

      @contacts[:person] = customer_xml.xpath('.//lastName').text + " " + customer_xml.xpath('.//firstName').text + " " + customer_xml.xpath('.//middleName').text
      @contacts[:phone] = customer_xml.xpath('.//phone').text
      @contacts[:email] = customer_xml.xpath('.//email').text
      @contacts[:fax] = customer_xml.xpath('.//fax').text

      @customer[:contacts] = @contacts
    end
  end
end