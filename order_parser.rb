class OrderParser
  
  def initialize
    @json = Hash.new
  end

  def get_info(info_page)
    page = Nokogiri::HTML(info_page, nil, 'utf-8')
    main_block = page.css("div.noticeTabBox")
    
    # //h2[following-sibling::table and parent::div[@class='noticeTabBoxWrapper']] - все h2 кроме последнего блока
    # //table[preceding-sibling::h2 and parent::div[@class='noticeTabBoxWrapper']] - все таблицы после h2 кроме последнего блока
    blocks_title = main_block[0].xpath("//h2[following-sibling::table and parent::div[@class='noticeTabBoxWrapper']]").to_a
    blocks = main_block[0].xpath("//table[preceding-sibling::h2 and parent::div[@class='noticeTabBoxWrapper']]").to_a
    
    # unless blocks_title.length == blocks.length
      puts "h2 is #{blocks_title.length}"
      puts "h2~table is #{blocks.length}"
      # return false
    # end

    file = File.new("parser.log", "w")

    temp_arr = Array.new
    blocks.each_with_index do |block_title, index|
      # temp_json = Hash.new
      puts index
      if block_title.next_element().name == "table"
        tmp = block_title.to_s + block_title.next_element.to_s
      else
        tmp = block_title.to_s
        index += 1
        # skip next iteration
      end
      temp_arr << tmp
      file.write blocks[index]
      file.write "\n-------------------------------------------------------------\n\n\n"
      # if blocks[index].name() == 'table'
        # puts block_title.text()
        # puts "if"
        # tr_tags = Array.new
        # tr_tags = blocks[index].css("tr")

        # tr_tags.each_with_index do |tr_tag, i|
          # key = tr_tag.css(".fontBoldTextTd/text()")[0]
          # val = tr_tag.css(".fontBoldTextTd ~ *").to_a
          # puts key.to_s
          # puts val[0]
          # puts i.to_s
          # puts val[0].class
          # puts "-------------------------------------------------------------"
          # org = val[0].xpath('//a[contains(@href, "/organization/")]').to_a
          # if !org.empty?
            # puts clean_trash(org[0]["href"].to_s)
            # puts "------------------------------------"
          # end
          # temp_json[key] = val
          # puts key
          # puts val
        # end
      # elsif !blocks[index].at_xpath("//table[not(@*)]").nil? #or !blocks[index].at_xpath("/table[not(@*)]").empty?
        # puts "empty table"
        # puts index
        # temp = blocks[index].to_s
        # clean_trash(temp)
        # file.write temp
      # elsif !blocks[index].at_xpath("//table[@class='contractSpecificationsDescriptTbl']").nil? #or !blocks[index].at_xpath("//table[@class='contractSpecificationsDescriptTbl']").empty?
        # puts "elsif"
        # first_block_key = blocks[index].css(".noticeTdFirst.fontBoldTextTd")[0].text()
        # first_block_value = blocks[index].css(".noticeTdFirst.fontBoldTextTd ~ td")[0].text()
        # temp_json[first_block_key] = first_block_value

        # puts blocks[index].name()
        # puts blocks[index]
        # temp = blocks[index].to_s
        # clean_trash(temp)
        # file.write temp
        # puts "-------------------------------------------------------------"
        # parse table to hash of arrays
      # else
        # puts "else"
        # puts "-------------------------------------------------------------"
      # end
      # @json[block_title] = temp_json
      # @json[key.text()] = ....
    end

    file.close

    # @json.each do |key, value|
    #   puts "#{key} is #{value}"
    #   puts "-------------------------------------------------------------"
    # end

    # arr.each do |div|
    #   key = div.css(".noticeTabBoxWrapper ~ h2")
    #   puts key
    # end
    # arr.each{|block| block.css("tr").each{ |tr| result << tr } }
    
    # result.each do |element|
    #   key = element.css(".fontBoldTextTd/text()").to_s
    #   clean_trash(key)
    #   val = element.css(".fontBoldTextTd ~ *").to_s
    #   clean_trash(val)
    #   @json[key] = val
    # end

    # @json.each do |key, value|
    #   puts "#{key} is #{value}"
    #   puts "-------------------------------------------------------------"
    # end
  end

  def get_docs(docs_page)
    page = Nokogiri::HTML(docs_page, nil, 'utf-8')
    main_block = page.css("div.noticeTabBox")

    blocks_title = main_block[0].css("h2").to_a
    blocks = main_block[0].xpath("//h2/following-sibling::table").to_a

    unless blocks_title.length == blocks.length
      puts "h2 is #{blocks_title.length}"
      puts "h2~div is #{blocks.length}"
      return false
    end

    file = File.new("parser.log", "w")

    blocks_title.each_with_index do |block_title, index|
      temp_json = Hash.new
      arr = Array.new

      arr = blocks[index].css("a")
      arr.each do |a|
        if a["href"] =~ /filestor/
          key = a.text().to_s
          clean_trash(key)
          val = a["href"].to_s
          temp_json[key] = val

          puts "#{key} is #{val}"
        end
      end
      # key = blocks[index].css(".fontBoldTextTd/text()").to_s
      #   val = blocks[index].css(".fontBoldTextTd ~ *").to_s
      #   temp_json[key] = val

      @json[block_title.to_s] = temp_json
      puts "#{block_title.to_s} is #{temp_json}"
    end

    file.write @json
    # puts @json
    file.close

    # main_block = page.css("div.noticeTabBox")
    # arr = main_block[0].css("table#notice-documents") # <table id="notice-documents">

    # result = Array.new

    # arr.each do |elem|
    #   elem.css("a").each{ |el| puts el.text() if el["href"] =~ /filestor/} # result << el if el["href"] =~ /filestor/
    # end


    # result.each do |elem|

    #   puts "-------------------------------------------------------------"
    #   puts elem["href"]
    #   puts elem["href"].text()
      
    #   puts "###########################################################"

    #   # doc = DocLoader.new(name)
    #   # d = doc.load_file

    #   # File.open("F:\\www\\zakupki\\" + name + ".doc", "wb") do |f|
    #     # f.write d.parsed_response
    #   # end
    # end
  end

  def get_event(event_page)
    
    page = Nokogiri::HTML(event_page, nil, 'utf-8')
    main_block = page.css("table#event")
    arr = main_block[0].xpath("//tbody/tr")

    arr.each do |elem|
      # puts elem
      # puts "-------------------------------------------------------------"
      key = elem.xpath("td[1]/text()").to_s
      clean_trash(key)
      value = elem.xpath("td[2]/text()").to_s
      clean_trash(value)
      @json[key] = value
      # puts key
    end

    @json.each do |key, value|
      puts "#{key} is #{value}"
      puts "-------------------------------------------------------------"
    end

  end
end