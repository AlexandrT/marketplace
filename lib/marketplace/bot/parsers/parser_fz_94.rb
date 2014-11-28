module Marketplace
  class Bot::Parsers::ParserFz94 < Bot::Parsers::Base

    # Поочередно вызывает методы для парсинга закупки
    # @param info_page [String] Страница закупки
    # @example
    #   fill_json("<html> </html>")
    def fill_json(info_page)
      info_page = Nokogiri::XML(info_page)

      get_order_info(info_page)
      contacts_xml = info_page.xpath('//notification/contactInfo').first
      get_auth_organization(contacts_xml)
      get_contacts(contacts_xml)

      lots_xml = info_page.xpath('//notification/lots').first
      get_all_lots(lots_xml)
    end

    # Наполняет **@order_json** основной информацией о закупке
    # @param info_page [Nokogiri::XML::Node] 
    def get_order_info(info_page)
      @order_json[:remote_id] = get_content(info_page, '//notification/notificationNumber')
      @order_json[:type] = get_content(info_page, '//notification/placingWay/name')
      @order_json[:name] = get_content(info_page, '//notification/orderName')
    end

    # Получает контакты авторизованной организации, сохраняет их в **@auth_organization_json**
    # @param contacts_xml [Nokogiri::XML::Node] 
    def get_contacts(contacts_xml)
      @contacts_json[:person] = get_content(contacts_xml, './/contactPerson/lastName') + " " + get_content(contacts_xml, './/contactPerson/firstName') + " " + get_content(contacts_xml, './/contactPerson/middleName')
      @contacts_json[:phone] = get_content(contacts_xml, './/contactPhone')
      @contacts_json[:email] = get_content(contacts_xml, './/contactEMail')
      @contacts_json[:fax] = get_content(contacts_xml, './/contactFax')

      @auth_organization_json[:contacts] = @contacts_json
    end

    # Наполняет хэш **@auth_organization_json** информацией об авторизованной организации
    # @param contacts_xml [Nokogiri::XML::Node] 
    def get_auth_organization(contacts_xml)
      @auth_organization_json[:full_name] = get_content(contacts_xml, './/orgName')
      @auth_organization_json[:short_name] = get_content(contacts_xml, './/orgShortName')
      @auth_organization_json[:inn] = get_content(contacts_xml, './/orgInn')
      @auth_organization_json[:kpp] = get_content(contacts_xml, './/orgKpp')
      # @auth_organization_json[:ogrn]
      @auth_organization_json[:address] = get_content(contacts_xml, './/orgFactAddress')
      @auth_organization_json[:post_address] = get_content(contacts_xml, './/orgPostAddress')
      @auth_organization_json[:phone] = get_content(contacts_xml, './/contactPhone')
      @auth_organization_json[:fax] = get_content(contacts_xml, './/contactFax')
      @auth_organization_json[:email] = get_content(contacts_xml, './/contactEMail')
      # @auth_organization_json[:okato]
    end

    # Получает информацию о лотах закупки, далее вызывает парсинг каждого отдельного лота
    # @param lots_xml [Nokogiri::XML::Node] 
    def get_all_lots(lots_xml)
      lots_set = lots_xml.xpath('.//lot')

      lots_set.each do |lot|
        get_common_lot_info(lot)
        
        ######### Refactoring ###########
        customer_xml = lot.xpath('.//customerRequirements/customerRequirement/organization').first
        get_customer(customer_xml)

        lot_items_xml = lot.xpath('.//customerRequirements/customerRequirement').first #.text
        ##################################

        lot_items_xml.each do |lot_item_xml|
          get_lot_item_info(lot_item_xml)
        end
      end
    end

    # Получает параметры лота и сохраняет в **@lot_json**
    # @param lot [Nokogiri::XML::Node] 
    def get_common_lot_info(lot)
      @lot_json[:name] = get_content(lot, './/subject')
      @lot_json[:currency] = get_content(lot, './/currency/code')
      @lot_json[:price] = get_content(lot, './/maxPrice')
      @lot_json[:okdp] = get_content(lot, './/products/product/code')
    end

    # Получает параметры каждого отдельного лота и добавляет их в **@order_json**
    # @param lot_item_xml [Nokogiri::XML::Node]
    def get_lot_item_info(lot_item_xml)
      lot_item = Hash.new

      lot_item[:count] = get_content(lot_item_xml, './/quantity')
      lot_item[:delivery_place] = get_content(lot_item_xml, './/deliveryPlace')

      @order_json[:lots] << lot_item
    end

    # Получает информацию о заказчике каждого лота и сохраняет ее в **@lot_json**
    # @param customer_xml [Nokogiri::XML::Node]
    def get_customer(customer_xml)
      contacts = Hash.new

      @customer_json[:name] = get_content(customer_xml, '//organization/fullName')
      @customer_json[:real_address] = get_content(customer_xml, '//factualAddress/addressLine')
      @customer_json[:post_address] = get_content(customer_xml, '//organization/postalAddress')

      contacts[:person] = get_content(customer_xml, './/contactPerson/lastName') + " " + get_content(customer_xml, './/contactPerson/firstName') + " " + get_content(customer_xml, './/contactPerson/middleName')
      contacts[:phone] = get_content(customer_xml, './/phone')
      contacts[:email] = get_content(customer_xml, './/email')
      contacts[:fax] = get_content(customer_xml, './/fax')

      @customer_json[:contacts] = contacts
      
      @lot_json[:customer] = @customer_json
    end

    # Получает текст первого совпадения по _xpath_ указанного тэга по _xpath_ 
    # @param xml [Nokogiri::XML::Node]
    # @param xpath_str [String] _xpath_
    def get_content(xml, xpath_str)
      xml.xpath(xpath_str).first.text
    end
  end
end