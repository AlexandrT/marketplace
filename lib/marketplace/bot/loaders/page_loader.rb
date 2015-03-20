require 'httparty'
  
module Marketplace
  class Bot::Loaders::PageLoader
    include HTTParty
    
    # Сообщения дебага при загрузке
    debug_output $stdout

    # Заголовки, передаваемые в каждом запросе
    headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
    headers 'referer' => 'http://zakupki.gov.ru'

    # Имя домена
    base_uri 'zakupki.gov.ru'

    # Прокся, используемая при загрузке
    http_proxy 'http://foo.com', 80, 'user', 'pass'

    # URI для закупок типа **fz_44**
    FZ_44 = "/epz/order/notice/printForm/view.html"

    # URI для закупок типа **fz_94**
    FZ_94 = "/pgz/printForm"

    # URI для закупок типа **fz_223**
    FZ_223 = "/223/purchase/public/notification/print-form/show.html"

    # Таймаут при повторе запроса на 5хх ошибке
    TIMEOUT = 20

    def initialize
      @producer = Producer.instance
    end

    # Приводит цену к виду, используемому в URL закупок
    # @param price [Integer] Стоимость для форматирования
    # return [String] "200+000+000"
    # @example
    #   format_price(200000000)
    def format_price(price)
      price.to_s.reverse.scan(/.{1,3}/).join("+").reverse
    end

    # Скачивает страницу со списком закупок
    # @param start_price [Integer] Начальная стоимость закупки
    # @param end_price [Integer] Конечная стоимость закупки
    # @return [HTTParty::Response]
    # @example
    #   list(0, 200000000)
    def load_list(start_price, end_price)
      
      @start_price = start_price
      @end_price = end_price

      case type
      # TODO
      # dry!
      when "fz44"
        url = "/epz/order/quicksearch/update.html?placeOfSearch=FZ_44&_placeOfSearch=on&_placeOfSearch=on&_placeOfSearch=on&priceFrom=" + format_price(@start_price) + "&priceTo=" + format_price(@end_price) + "&publishDateFrom=" + @producer.start_date + "&publishDateTo=" + @producer.end_date + "&updateDateFrom=" + @producer.start_date + "&updateDateTo=" + @producer.end_date + "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=" + @producer.page_number + "&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=true&isHeaderClick=&checkIds="
      when "fz94"
        url = "/epz/order/quicksearch/update.html?_placeOfSearch=on&_placeOfSearch=on&placeOfSearch=FZ_94&_placeOfSearch=on&priceFrom=" + format_price(@start_price) + "&priceTo=" + format_price(@end_price) + "&publishDateFrom=" + @producer.start_date + "&publishDateTo=" + @producer.end_date + "&updateDateFrom=" + @producer.start_date + "&updateDateTo=" + @producer.end_date + "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=" + @producer.page_number + "&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=true&isHeaderClick=&checkIds="
      when "fz223"
        url = "/epz/order/quicksearch/update.html?_placeOfSearch=on&placeOfSearch=FZ_223&_placeOfSearch=on&_placeOfSearch=on&priceFrom=" + format_price(@start_price) + "&priceTo=" + format_price(@end_price) + "&publishDateFrom=" + @producer.start_date + "&publishDateTo=" + @producer.end_date + "&updateDateFrom=" + @producer.start_date + "&updateDateTo=" + @producer.end_date + "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=" + @producer.page_number + "&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=true&isHeaderClick=&checkIds="
      else
        puts "Unknown order type in PageLoader"
      end
      response = self.class.get(url)
      analyze_list_response(response)
    end

    # Анализирует ответ сервера по коду ответа и принимает решение для дальнейших действий.
    # Если проблемы сервера (5хх ошибка), то перепосылаем задание на загрузку через TIMEOUT секунд.
    # Если загрузка удачная (код 200), то отправляем задание на парсинг.
    # @note При ошибках отличных от 200 и 5хх, просто сообщение в лог
    # @param response [HTTParty::Response] Ответ сервера на get-запрос
    # @example
    #   analyze_list_response(response)
    def analyze_list_response(response)
      code = response.code

      case code.to_i
      when 500...599
        sleep TIMEOUT
        @producer.load_list(@start_price, @end_price)
      when 200
        @producer.parse_list(response.body, @start_price, @end_price)
      else
        puts "Strange response code during list load - #{code}"
      end
    end

    # Скачивает страницу с закупкой
    # @param id [String] id закупки
    # @return [HTTParty::Response]
    # @example
    #   load_order("10004234")
    def load_order(id)
      case @type
      when "fz_44"
        options = { query: { regNumber: id } }
        response = self.class.get(FZ_44, options)
      when "fz_94"
        options = { query: { type: "NOTIFICATION", id: id } }
        response = self.class.get(FZ_94, options)
      when "fz_223"
        options = { query: { noticeId: id } }
        response = self.class.get(FZ_223, options)
      else
        puts "unknown order type"
      end

      analyze_order_response(response)
    end

    # Анализирует ответ сервера по коду ответа и принимает решение для дальнейших действий.
    # Если проблемы сервера (5хх ошибка), то перепосылаем задание на загрузку через TIMEOUT секунд.
    # Если загрузка удачная (код 200), то отправляем задание на парсинг.
    # @note При ошибках отличных от 200 и 5хх, просто сообщение в лог
    # @param response [HTTParty::Response] Ответ сервера на get-запрос
    # @example
    #   analyze_order_response(response)
    def analyze_order_response(response)
      code = response.code

      case code.to_i
      when 500...599
        sleep TIMEOUT
        @producer.load_order
      when 200
        @producer.parse_order(response.body)
      else
        puts "Strange response code during order load - #{code}"
      end
    end
  end
end