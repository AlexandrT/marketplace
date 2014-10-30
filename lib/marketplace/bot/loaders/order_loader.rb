# encoding: UTF-8

require 'httparty'
require 'nokogiri'

module Marketplace
  class Bot::Loaders::OrderLoader
  	include HTTParty
  	debug_output $stdout
  	headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
  	headers 'referer' => 'http://zakupki.gov.ru'
  	base_uri 'zakupki.gov.ru'
    http_proxy 'http://foo.com', 80, 'user', 'pass'

	  INFO = "/epz/order/notice/ea44/view/common-info.html"
	  DOCS = "/epz/order/notice/ea44/view/documents.html"
	  EVENT_LOG = "/epz/order/notice/ea44/view/event-log.html"
	  PRINT_FORM = "/epz/order/notice/printForm/view.html"
  
  	def initialize(id)
  		@id = id
  		@options = { query: { regNumber: @id } }
  	end

  	def info
  		self.class.get(INFO, @options)
  	end

	  def docs
	  	self.class.get(DOCS, @options)
	  end

	  def event_log
	  	self.class.get(EVENT_LOG, @options)
	  end

	  def print_form
	  	self.class.get(PRINT_FORM, @options)
	  end
  end
end