# encoding: UTF-8

require 'httparty'

class CompanyLoader
  include HTTParty
  # debug_output $stdout
  headers 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)'
  headers 'referer' => 'http://zakupki.gov.ru'
  base_uri 'zakupki.gov.ru'
  # http_proxy 'http://foo.com', 80, 'user', 'pass'

  # url - полный адрес на страницу компании
  def get_page(url)
    self.class.get(url)
  end

end