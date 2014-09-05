module Marketplace
  class ParserFz223 < OrderParserXml

    def fill_json(info_page)
      lot_json = Hash.new
      delivery_place = Hash.new
      lot_item = Hash.new
      lot_items = Array.new
      lots = Array.new

      page = Nokogiri::HTML(clean_trash(info_page), nil, 'utf-8')

      xml = page.xpath('//div[@id="tabs-2"]')[0]

      @order_json[:remote_id] = xml.xpath('.//ns2:registrationNumber')
      @order_json[:name] = xml.xpath('.//ns2:name')
      @order_json[:type] = xml.xpath('.//ns2:purchaseCodeName')

      customer_xml = xml.xpath('//ns2:customer/mainInfo')
      @customer = Hash.from_xml(customer_xml)

      lots_xml = xml.xpath('//ns2:lots/lot')

      lots_xml.each do |lot|
        lot_json[:name] = lot.xpath('.//lotData/subject')
        lot_json[:currency] = lot.xpath('.//lotData/currency/code')
        lot_json[:price] = lot.xpath('.//lotData/initialSum')

        delivery_xml = lot.xpath('.//deliveryPlace')
        delivery_place = Hash.from_xml(delivery_xml)
        lot_json[:delivery_place] = delivery_place
        
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

  end
end