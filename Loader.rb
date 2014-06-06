require 'net/http'


class Loader
	FIRST_PATH_URL = "http://zakupki.gov.ru/epz/order/quicksearch/update.html?placeOfSearch=FZ_44&_placeOfSearch=on&placeOfSearch=FZ_223&_placeOfSearch=on&placeOfSearch=FZ_94&_placeOfSearch=on&priceFrom=0&priceTo=200+000+000+000&publishDateFrom="
	SECOND_PATH_URL = "&publishDateTo="
	THIRD_PATH_URL = "&updateDateFrom="
	FORTH_PATH_URL = "&updateDateTo="
	FIVES_PATH_URL = "&orderStages=AF&_orderStages=on&orderStages=CA&_orderStages=on&orderStages=PC&_orderStages=on&orderStages=PA&_orderStages=on&sortDirection=false&sortBy=UPDATE_DATE&recordsPerPage=_50&pageNo=1&searchString=&strictEqual=false&morphology=false&showLotsInfo=false&isPaging=false&isHeaderClick=&checkIds="
		

	def initialize(type, startDate, endDate)
		self.startDate = startDate
		self.endDate = endDate
		#page = Net::HTTP.get('stackoverflow.com', '/index.html')
		# Factory.build_loader(type)
	end

	def create()
		url = FIRST_PATH_URL + startDate + SECOND_PATH_URL + endDate + THIRD_PATH_URL + FORTH_PATH_URL + FIVES_PATH_URL
	end

	def update()
		url = FIRST_PATH_URL + SECOND_PATH_URL + THIRD_PATH_URL + startDate + FORTH_PATH_URL + endDate + FIVES_PATH_URL
	end
end


# class Factory
# 	extend self

# 	def self.build_loader(type)
# 		case type
# 			when :create then Loader.create()
# 			when :update then Loader.update()
# 		end
# 	end
# end






source = Loader.new("create", "2014-06-03", "2014-06-04")

puts source.inspect