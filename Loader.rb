# encoding: UTF-8

require 'net/http'
require 'nokogiri'
require 'open-uri'

class Loader
	HOST = "http://zakupki.gov.ru"
	FIRST_PATH_URL = "/epz/order/quicksearch/search.html?placeOfSearch=FZ_44&_placeOfSearch=on&placeOfSearch=FZ_223&_placeOfSearch=on&placeOfSearch=FZ_94&_placeOfSearch=on&priceFrom=0&priceTo=200+000+000+000&publishDateFrom="
	# URI.encode_www_form("placeOfSearch" => ["FZ_44&_placeOfSearch=on", "FZ_223&_placeOfSearch=on", "FZ_94&_placeOfSearch=on"], "priceFrom" => "0", "priceTo" => "200+000+000+000")
	SECOND_PATH_URL = "&publishDateTo="
	THIRD_PATH_URL = "&updateDateFrom="
	FORTH_PATH_URL = "&updateDateTo="
	FIVES_PATH_URL = "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=1&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=false&isHeaderClick=&checkIds="
		
	def initialize(type, start_date, end_date)
		# check dates - start_date <= end_date, now()-30d <= date <= now()
		@start_date, @end_date = start_date, end_date

		if type == "create"
			@url = FIRST_PATH_URL + @start_date + SECOND_PATH_URL + @end_date + THIRD_PATH_URL + FORTH_PATH_URL + FIVES_PATH_URL
		elsif type == "update"
			@url = FIRST_PATH_URL + SECOND_PATH_URL + THIRD_PATH_URL + @start_date + FORTH_PATH_URL + @end_date + FIVES_PATH_URL
		end
	end

	def run()
		# puts @url
		http = Net::HTTP.new("zakupki.gov.ru")
		headers = {
			"User-Agent" => "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"
		}
		res = http.get(@url,headers)
		puts res.body
		# response = Net::HTTP.get(URI @url)
		# puts response
		# page = Nokogiri::HTML(response)
	end
end

class ListParser
end


source = Loader.new("create", "03.06.2014", "04.06.2014")

page = source.run()

puts page