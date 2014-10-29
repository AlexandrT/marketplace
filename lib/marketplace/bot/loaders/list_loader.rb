require 'httparty'
  
module Marketplace
  class Bot::Loaders::ListLoader
    include HTTParty
    debug_output $stdout
    headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
    headers 'referer' => 'http://zakupki.gov.ru'
    base_uri 'zakupki.gov.ru'
    logger Logger.new 'http_logger.log', :info, :apache
    http_proxy 'http://foo.com', 80, 'user', 'pass'
    
    # Скачивает страницу со списком закупок
    # @note 
    # @param start_date [String] начальная дата создания/обновления закупки
    # @param end_date [String] конечная дата создания/обновления закупки
    # @param page_number [Integer] номер загружаемой страницы
    # @return [HTTParty::Response]
    # @example
    #   list('09.21.2014', '09.22.2014', 4)
    def list(start_date, end_date, page_number)
      url = "/epz/order/quicksearch/update.html?placeOfSearch=FZ_44&_placeOfSearch=on&placeOfSearch=FZ_223&_placeOfSearch=on&placeOfSearch=FZ_94&_placeOfSearch=on&priceFrom=0&priceTo=200+000+000+000&publishDateFrom=" + start_date + "&publishDateTo=" + end_date + "&updateDateFrom=" + start_date + "&updateDateTo=" + end_date + "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=" + page_number + "&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=true&isHeaderClick=&checkIds="
      self.class.get(url)
    end
  end
end