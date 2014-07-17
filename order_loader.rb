# encoding: UTF-8

require 'httparty'
require 'nokogiri'

class OrderLoader
	include HTTParty
	# debug_output $stdout
	headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
	headers 'referer' => 'http://zakupki.gov.ru'
	base_uri 'zakupki.gov.ru'
  # http_proxy 'http://foo.com', 80, 'user', 'pass'

	# usual
	INFO = "/epz/order/notice/ea44/view/common-info.html" # ?regNumber=0102200001614001856
	DOCS = "/epz/order/notice/ea44/view/documents.html" # ?regNumber=0102200001614001856
	EVENT_LOG = "/epz/order/notice/ea44/view/event-log.html" # ?regNumber=0102200001614001856
	PRINT_FORM = "/epz/order/notice/printForm/view.html" # ?regNumber=0102200001614001856

	# def initialize(hash, url)
	# 	# url = self.const_get("SOLO_#{type.upcase}")
	# 	@url = url
	# 	@id = hash[:id]
	# 	case hash[:type]
	# 		when "usual"
	# 			@options = { query: { regNumber: @id } }
	# 			puts INFO
	# 		when "solo"
	# 			@options = { query: { noticeId: @id, epz: true } }
	# 			puts INFO_SOLO
	# 		else
	# 			puts "unknown type"
	# 	end
	# end

	def initialize(id)
		# url = self.const_get("SOLO_#{type.upcase}")
		@id = id
		@options = { query: { regNumber: @id } }
	end

	def info
		self.class.get(INFO, @options)
		# check response-status
    # case response.code
  		# when 200
    		# puts "All good!"
  		# when 404
    		# puts "page not found!"
  		# when 500...600
    		# puts "ERROR #{response.code}"
		# end
	end

	def docs
		self.class.get(DOCS, @options)
		# check response-status
    # case response.code
  		# when 200
    		# puts "All good!"
  		# when 404
    		# puts "page not found!"
  		# when 500...600
    		# puts "ERROR #{response.code}"
		# end
	end

	def event_log
		self.class.get(EVENT_LOG, @options)
		# check response-status
    # case response.code
  		# when 200
    		# puts "All good!"
  		# when 404
    		# puts "page not found!"
  		# when 500...600
    		# puts "ERROR #{response.code}"
		# end
	end

	def print_form
		self.class.get(PRINT_FORM, @options)
		# check response-status
    # case response.code
  		# when 200
    		# puts "All good!"
  		# when 404
    		# puts "page not found!"
  		# when 500...600
    		# puts "ERROR #{response.code}"
		# end
	end
end

#obj = ListParser.new
#ids = obj.get_ids("03.06.2014", "03.06.2014") #array of links
  #http://zakupki.gov.ru/223/purchase/public/purchase/info/common-info.html?noticeId=1239485&epz=true
  #/epz/order/notice/ea44/view/common-info.html?regNumber=0128200000114003315

#orders = split_array(ids) # [ {id: 0128200000114003315, type: "usual"}, {id: 1239485, type: "solo"} ]

#unless orders.empty?
#	orders.each do |hash|
#		case hash[:type] # create and use factory
#			when "usual"
#				obj = OrderLoader.new(hash[:id])
#				info_page = obj.info
#				parser = OrderParser.new
#				@json = Hash.new

#			when "solo"
#				obj = OrderSoloLoader.new(hash[:id])
#				info_page = obj.info
#		end
#	end
#end
# obj = OrderLoader.new("0173100006514000048")
# # info_page = obj.info
# # puts info_page
# parser = OrderParser.new
# # parser.get_info(info_page)

# # docs_page = obj.docs
# # parser.get_docs(docs_page)

# event_page = obj.event_log
# parser.get_event(event_page)