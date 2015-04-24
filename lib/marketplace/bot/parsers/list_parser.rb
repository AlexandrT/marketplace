require 'nokogiri'

module Marketplace
  class Bot::Parsers::ListParser

    def initialize
      @producer = Marketplace::Bot::Producers::Producer.instance
    end

    # Парсит страницу, получает массив _id_ закупок, вызывает продюсера для создания таска загрузки каждой закупки.
    # Если есть ссылка на следующую страницу, вызывает продюсера для создания таска на загрузку следующей страницы.
    # Если число подходящих закупок больше тысячи, то вызывается продюсер для создания двух заданий на загрузку списка закупок с мин/макс ценами, деленными на 2 (как при бинарном поиске)
    # @param page [String] Страница для парсинга
    # @param start_price [Integer] Минимальная стоимость закупки
    # @param end_price [Integer] Максимальная стоимость закупки
    # @example
    #   get_ids("<html</html", 0, 200000000)
    def get_ids(page, start_price, end_price)
      orders_url = []
      
      page = Nokogiri::HTML(page, nil, 'utf-8')
      
      order_count = get_count(page)

      if order_count > 1000
        @producer.load_list(start_price, end_price/2)
        @producer.load_list(end_price/2 + 1, end_price)
      else
        page.xpath("//a[child::span[@class='printBtn']]").each{ |link| orders_url << link["href"] }
        if page.at_css(".rightArrow")
          @producer.increment_page_number(1)
          @producer.load_list
        end

        orders_url.each do |order_url|
          @producer.load_order(order_url)
        end
      end
    end
    
    # Получает со страницы с закупками кол-во записей в выдаче.
    # Со страницы получаем <div class='allRecords'>, берем из блока текст, парсим число и приводим его к int.
    # @param page [Nokogiri::HTML] Страница для парсинга
    # @return [Fixnum] количество закупок в поисковой выдаче
    # @example 
    #   get_count(page)
    def get_count(page)
      begin
        page.xpath("//div[@class='allRecords']").first.text[/\d+/].to_i
      rescue Exception => e
        puts e
        # puts "Something with page"
      end
    end
  end

end
