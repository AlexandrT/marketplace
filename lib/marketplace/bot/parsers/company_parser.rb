# encoding: UTF-8

require "byebug"

module Marketplace
  class Bot::Parsers::CompanyParser
    def initialize
      @json_company = Hash.new
    end

    def get(company_page)
      page = Nokogiri::HTML(company_page, nil, 'utf-8')
      # file = File.new("parser.log", "w")
      main_block = page.xpath('//td[@class="icePnlGrdCol mainPageCol paddL10 paddR10"]')

      # NodeSet ключей хэша
      tags_td = main_block[0].xpath('//td[@class="iceOutLbl"]')


      embedded_flag = false
      temp_json = Hash.new

      tags_td.each do |tag_td|
        unless tag_td.get_attribute('style') == 'padding-left:10px'
          if embedded_flag
            @json_company[@last_key] = temp_json
            embedded_flag = false
            # temp_json.clear
          end
          key = tag_td.to_s
          val = tag_td.next_element().to_s
          @json_company[key] = val
          @last_key = key
        else
          key = tag_td.to_s
          val = tag_td.next_element().to_s
          temp_json[key] = val
          embedded_flag = true
        end
      end

      puts "\n\n"
      @json_company.each do |elem|
        puts elem
        puts "==========================================================================="
      end
    end
  end
end