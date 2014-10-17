module Marketplace
  class Bot::Parsers::ParserFz94 < Bot::Parsers::OrderParserXml
    def fill_json(info_page)
      info_page = Nokogiri::XML(info_page)

      get_order_info(info_page)
      contacts_xml = info_page.xpath('//notification/contactInfo')[0]
      get_auth_organization(contacts_xml)
      get_contacts(contacts_xml)

      lots_xml = info_page.xpath('//notification/lots')[0]
      get_all_lots(lots_xml)
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

    def get_all_lots(lots_xml)
      lots_set = lots_xml.xpath('.//lot')

      # жсон с отдельным лотом. после наполнения сливаем его в массив лотов
      lot_json = Hash.new

      # хэш с пунктами, входящими в лот  (<lotItem>)
      lot_item = Hash.new

      # массив со всеми пунктами лота, сливается в lots для каждого отдельного лота
      lot_items = Array.new

      # массив со всеми лотами, который сливаем в @order_json
      lots = Array.new

      lots_set.each do |lot|
        get_common_lot_info(lot)
        
        ######### Refactoring ###########
        customer_xml = lot.xpath('.//customerRequirements/customerRequirement/organization')
        get_customer(customer_xml)

        lot_items_xml = lot.xpath('.//customerRequirements/customerRequirement').text
        ##################################

        lot_items_xml.each do |lot_item_xml|
          get_lot_item_info(lot_item_xml)
        end
      end
    end

    def get_common_lot_info(lot)
      @lot_json[:name] = lot.xpath('.//subject').first.text
      @lot_json[:currency] = lot.xpath('.//currency/code').first.text
      @lot_json[:price] = lot.xpath('.//maxPrice').first.text
      @lot_json[:okdp] = lot.xpath('.//products/product/code').text
    end

    def get_lot_item_info(lot_item_xml)
      lot_item = Hash.new

      lot_item[:count] = lot_item_xml.xpath('.//quantity').text
      lot_item[:delivery_place] = lot_item_xml.xpath('.//deliveryPlace').text

      @order_json[:lots] << lot_item
    end

    def get_customer(customer_xml)
      contacts = Hash.new

      @customer_json[:name] = customer_xml.xpath('//organization/fullName').first.text
      @customer_json[:real_address] = customer_xml.xpath('//factualAddress/addressLine').first.text
      @customer_json[:post_address] = customer_xml.xpath('//organization/postalAddress').text

      contacts[:person] = customer_xml.xpath('.//contactPerson/lastName').text + " " + customer_xml.xpath('.//contactPerson/firstName').text + " " + customer_xml.xpath('.//contactPerson/middleName').text
      contacts[:phone] = customer_xml.xpath('.//phone').text
      contacts[:email] = customer_xml.xpath('.//email').text
      contacts[:fax] = customer_xml.xpath('.//fax').text

      @customer_json[:contacts] = contacts
      
      @lot_json[:customer] = @customer_json
    end
  end
end