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

	def initialize(id)
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