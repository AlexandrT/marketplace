# encoding: UTF-8

require "byebug"

class CompanyParser
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
      byebug
      unless tag_td.get_attribute('style') == 'padding-left:10px'
        # file.write "unless\n"
        # file.write tag_td
        # file.write "\n-------------------------------------------------------------\n\n"
        if embedded_flag
          @json_company[@last_key] = temp_json
          embedded_flag = false
          # temp_json.clear
          # file.write "last_key in if = #{@last_key}\n"
        end
        key = tag_td.to_s
        val = tag_td.next_element().to_s
        @json_company[key] = val
        @last_key = key
        # file.write "last_key = #{@last_key}\n"
      else
        # file.write "else\n"
        # file.write tag_td
        # file.write "\n-------------------------------------------------------------\n\n"
        key = tag_td.to_s
        val = tag_td.next_element().to_s
        temp_json[key] = val
        embedded_flag = true
      end
    end

    # @json_company.each do |key, value|
    #   if value.is_a?(Hash)
    #     value.each do |embedded_key, embedded_value|
    #       file.write "      #{embedded_key} is #{embedded_value}"
    #       file.write "      \n+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n"
    #     end
    #   end
    #   file.write "#{key} is #{value}"
    #   file.write "\n-------------------------------------------------------------\n\n"
    # end
    # file.close
  end
end