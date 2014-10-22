require 'nokogiri'

module Marketplace
  class Bot::Parsers::ListParser

    def get_ids(start_date, end_date)

      if check_date(start_date) and check_date(end_date)
        orders_id = []
        i = 0
        begin
          sleep Random.rand(15)
          i += 1
          page_num = i.to_s

          source = Bot::Loaders::ListLoader.new()  # date?
          page = page_source(source.list(start_date, end_date, page_num))
      
          page.xpath("//a[child::span[@class='printBtn']]").each{ |link| orders_id << link["href"] }
          break if i > 9
        end while page.at_css(".rightArrow")
        return orders_id
      end
    end

    def page_source(source)
      Nokogiri::HTML(source, nil, 'utf-8')
    end

    def check_date(input_date)
      if input_date.match(/^\d{2}\.\d{2}\.\d{4}$/)
        begin
          Date.parse(input_date)
        rescue ArgumentError
          # puts "can't parse date"
          return false
        end
      else
        # puts "wrong format"
        return false
      end
    end
  end
end
