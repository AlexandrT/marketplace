module Marketplace
  class ParserFz223 < OrderParserXml

    def fill_json(info_page)
      delivery_place = Hash.new
      page = Nokogiri::HTML(clean_trash(info_page), nil, 'utf-8')

      xml = page.xpath('//div[@id="tabs-2"]')[0]

      @order_json[:remote_id] = xml.xpath('.//ns2:registrationNumber')
      @order_json[:name] = xml.xpath('.//ns2:name')
      @order_json[:type] = xml.xpath('.//ns2:purchaseCodeName')

      customer_xml = xml.xpath('//ns2:customer/mainInfo')
      @customer = Hash.from_xml(customer_xml)

      lots_xml = xml.xpath('//ns2:lots/lot')

      lots_xml.each do |lot|
        @lots_json[:name] = lot.xpath('.//lotData/subject')
        @lots_json[:currency] = lot.xpath('.//lotData/currency/code')
        @lots_json[:price] = lot.xpath('.//lotData/initialSum')

        delivery_xml = lot.xpath('.//deliveryPlace')
        delivery_place = Hash.from_xml(delivery_xml)

        @lots_json[:delivery_place] = delivery_place
        @lots_json[:okdp] = lot.xpath('.//lotData/initialSum')
      end
    end

  end
end