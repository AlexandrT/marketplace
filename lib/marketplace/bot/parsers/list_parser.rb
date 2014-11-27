require 'nokogiri'

module Marketplace
  class Bot::Parsers::ListParser

    def initialize
      @producer = Producer.new
    end

    def get_ids(page, start_price, end_price)
      orders_id = []
      
      page = Nokogiri::HTML(page, nil, 'utf-8')
      order_count = page.xpath("//div[@class='allReords']").text
      if order_count > 1000
        @producer.load_list(start_price, end_price/2)
        @producer.load_list(end_price/2 + 1, end_price)
      else
        page.xpath("//a[child::span[@class='printBtn']]").each{ |link| orders_id << link["href"] }

        if page.at_css(".rightArrow")
          @producer.page_num += 1
          @producer.load_list
        end

        orders_id.each do |order_id|
          @producer.load_order(order_id)
        end
      end
  end
end
