require 'httparty'

class ListLoader
  include HTTParty
  # debug_output $stdout
  headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
  headers 'referer' => 'http://zakupki.gov.ru'
  base_uri 'zakupki.gov.ru'
  # logger Logger.new 'http_logger.log', :info, :apache
  # http_proxy 'http://foo.com', 80, 'user', 'pass' # if it's not work, remove http://

  def initialize
    # add pagination to pageNo
    #http://zakupki.gov.ru/epz/order/quicksearch/update.html?placeOfSearch=FZ_44&_placeOfSearch=on&placeOfSearch=FZ_223&_placeOfSearch=on&placeOfSearch=FZ_94&_placeOfSearch=on&priceFrom=0&priceTo=200+000+000+000&publishDateFrom=03.06.2014&publishDateTo=03.06.2014&updateDateFrom=03.06.2014&updateDateTo=03.06.2014&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_10&pageNo=1&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=false&isHeaderClick=&checkIds=
    # @options = { query: {placeOfSearch: "FZ_44", _placeOfSearch: "on", placeOfSearch: "FZ_223", _placeOfSearch: "on", placeOfSearch: "FZ_94", _placeOfSearch: "on", priceFrom: "0", priceTo: "200+000+000+000", publishDateFrom: start_date, publishDateTo: end_date, updateDateFrom: start_date, updateDateTo: end_date, orderStages: "AF", _orderStages: "on", orderStages: "CA", _orderStages: "on", orderStages: "PC", _orderStages: "on", orderStages: "PA", _orderStages: "on", sortDirection: "false", sortBy: "UPDATE_DATE", recordsPerPage: "_50", pageNo: page_number, searchString: "", strictEqual: "false", morphology: "false", showLotsInfo: "false", isPaging: "false", isHeaderClick: "", checkIds: ""} }
    # puts @options
  end

  def list(start_date, end_date, page_number)
    url = "/epz/order/quicksearch/update.html?placeOfSearch=FZ_44&_placeOfSearch=on&placeOfSearch=FZ_223&_placeOfSearch=on&placeOfSearch=FZ_94&_placeOfSearch=on&priceFrom=0&priceTo=200+000+000+000&publishDateFrom=" + start_date + "&publishDateTo=" + end_date + "&updateDateFrom=" + start_date + "&updateDateTo=" + end_date + "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=" + page_number + "&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=true&isHeaderClick=&checkIds="
    self.class.get(url)
    # self.class.get("/epz/order/quicksearch/update.html", @options)
    # check response-status
    # case response.code
      # when 200
        # puts "All good!"
      # when 404
        # puts "O noes not found!"
      # when 500...600
        # puts "ERROR #{response.code}"
    # end
  end
end