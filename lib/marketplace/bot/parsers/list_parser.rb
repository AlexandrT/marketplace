require 'nokogiri'

module Marketplace
  class Bot::Parsers::ListParser

    def initialize
      @producer = Marketplace::Bot::Producers::Producer.instance
    end

    # Парсит страницу, получает массив _id_ закупок, вызывает продюсера для создания таска загрузки каждой закупки.
    # Если есть ссылка на следующую страницу, вызывает продюсера для создания таска на загрузку следующей страницы.
    # Если число подходящих закупок больше тысячи, то вызывается продюсер для создания двух заданий на загрузку списка закупок с мин/макс ценами, деленными на 2 (как при бинарном поиске)
    # param page [String] Страница для парсинга
    # param start_price [Integer] Минимальная стоимость закупки
    # param end_price [Integer] Максимальная стоимость закупки
    # example
    #   get_ids("<html</html", 0, 200000000)
    def get_ids(page, start_price, end_price)
      orders_url = []
      
      page = Nokogiri::HTML(page, nil, 'utf-8')
      order_count = get_count(page)
      # строку с получением order_count можно вынести в отдельный метод
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
    # создать страницу без ссылок на следующую - стаб на @producer.load_order(order_id). order_id - кол-во закупок на странице
    # создать страницу со ссылкой на следующую, число закупок меньше тысячи - стаб на @producer.load_order(order_id). order_id - кол-во закупок на странице, @producer.load_list - таск на загрузку след. страницы
    # создать страницу со ссылкой на следующую, число закупок больше тысячи - стаб на @producer.load_list(start_price, end_price). @producer.load_list(start_price, end_price/2) и @producer.load_list(end_price/2 + 1, end_price)
    
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
