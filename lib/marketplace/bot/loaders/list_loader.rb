require 'httparty'
  
module Marketplace
  class Bot::Loaders::ListLoader
    include HTTParty
    # debug_output $stdout
    headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
    headers 'referer' => 'http://zakupki.gov.ru'
    base_uri 'zakupki.gov.ru'
    # logger Logger.new 'http_logger.log', :info, :apache
    # http_proxy 'http://foo.com', 80, 'user', 'pass'
    
    # Скачивает страницу со списком закупок
    # @param type [String] тип закупки
    # @param start_date [String] начальная дата создания/обновления закупки
    # @param end_date [String] конечная дата создания/обновления закупки
    # @param page_number [Integer] номер загружаемой страницы
    # @return [HTTParty::Response]
    # @example
    #   list("fz44", "09.21.2014", "09.22.2014", 4)
    def list(type, start_date, end_date, page_number)
        @type = type
        @start_date = start_date
        @end_date = end_date
        @page_number = page_number
      case type
      when "fz44"
        url = "/epz/order/quicksearch/update.html?placeOfSearch=FZ_44&_placeOfSearch=on&_placeOfSearch=on&_placeOfSearch=on&priceFrom=0&priceTo=200+000+000+000&publishDateFrom=" + start_date + "&publishDateTo=" + end_date + "&updateDateFrom=" + start_date + "&updateDateTo=" + end_date + "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=" + page_number + "&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=true&isHeaderClick=&checkIds="
      when "fz94"
        url = "/epz/order/quicksearch/update.html?_placeOfSearch=on&_placeOfSearch=on&placeOfSearch=FZ_94&_placeOfSearch=on&priceFrom=0&priceTo=200+000+000+000&publishDateFrom=" + start_date + "&publishDateTo=" + end_date + "&updateDateFrom=" + start_date + "&updateDateTo=" + end_date + "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=" + page_number + "&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=true&isHeaderClick=&checkIds="
      when "fz223"
        url = "/epz/order/quicksearch/update.html?_placeOfSearch=on&placeOfSearch=FZ_223&_placeOfSearch=on&_placeOfSearch=on&priceFrom=0&priceTo=200+000+000+000&publishDateFrom=" + start_date + "&publishDateTo=" + end_date + "&updateDateFrom=" + start_date + "&updateDateTo=" + end_date + "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=" + page_number + "&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=true&isHeaderClick=&checkIds="
      else
        puts "Unknown order type in ListLoader"
      end
      response = self.class.get(url)
      analyze(response)
    end

    # Анализирует ответ сервера по коду ответа и принимает решение для дальнейших действий.
    # Если проблемы сервера (5хх ошибка), то перепосылаем задание на загрузку через TIMEOUT секунд.
    # Если загрузка удачная (код 200), то отправляем задание на парсинг.
    # @note При ошибках отличных от 200 и 5хх, просто сообщение в лог
    # @param response [HTTParty::Response] ответ сервера на get-запрос
    # @example
    #   analyze(response)
    def analyze(response)
      code = response.code

      case code.to_i
      when 500...599
        sleep TIMEOUT
        Producer.load_list(@type, @start_date, @end_date, @page_number)
      when 200
        Producer.parse_list(@type, response.body)
      else
        puts "Strange response code during list load - #{code}"
      end
    end
  end
end