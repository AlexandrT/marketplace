module Marketplace
  class ParserFz94 < OrderParserXml
    def fill_json(info_page)
      info_page = Nokogiri::XML(info_page)

      get_order_info(info_page)

      contacts_xml = info_page.xpath('//notification/contactInfo')
      get_contacts(contacts_xml)
    end

    def get_order_info(info_page)
      @order_json[:remote_id] = info_page.xpath('//notification/notificationNumber')
      @order_json[:type] = info_page.xpath('//notification/placingWay/name')
      @order_json[:name] = info_page.xpath('//notification/orderName')
    end

    def get_contacts(contacts_xml)
      @contacts[:first_name] = contacts_xml.xpath('.//contactPerson/firstName')
      @contacts[:middle_name] = contacts_xml.xpath('.//contactPerson/middleName')
      @contacts[:last_name] = contacts_xml.xpath('.//contactPerson/lastName')
      @contacts[:phone] = contacts_xml.xpath('.//contactPhone')
      @contacts[:email] = contacts_xml.xpath('.//cantactEMail')
      @contacts[:fax] = contacts_xml.xpath('.//contactFax')

      @order_json[:contacts] = @contacts

      @customer[:full_name] = contacts_xml.xpath('.//orgName')
      @customer[:short_name] = contacts_xml.xpath('.//orgShortName')
      @customer[:inn] = contacts_xml.xpath('.//orgInn')
      @customer[:kpp] = contacts_xml.xpath('.//orgKpp')
      # @customer[:ogrn]
      @customer[:address] = contacts_xml.xpath('.//orgFactAddress')
      @customer[:post_address] = contacts_xml.xpath('.//orgPostAddress')
      @customer[:phone] = contacts_xml.xpath('.//contactPhone')
      @customer[:fax] = contacts_xml.xpath('.//contactFax')
      @customer[:email] = contacts_xml.xpath('.//cantactEMail')
      # @customer[:okato]
    end
  end
end