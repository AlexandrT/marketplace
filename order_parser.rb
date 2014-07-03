class OrderParser
  
  def initialize
    @json = Hash.new
  end

  def get_info(info_page)
    page = Nokogiri::HTML(info_page, nil, 'utf-8')
    main_block = page.css("div.noticeTabBox")
    
    blocks_title = main_block[0].css("h2").to_a
    blocks = main_block[0].xpath("//h2/following-sibling::div | //h2/following-sibling::table").to_a
    
    unless blocks_title.length == blocks.length
      puts "h2 is #{blocks_title.length}"
      puts "h2~div is #{blocks.length}"
      return false
    end

    blocks_title.each_with_index do |block_title, index|
      result = Array.new
      temp_json = Hash.new
      # puts block_title.text()
      # puts blocks[index].name()
      if blocks[index].name() == 'div'
        key = blocks[index].css(".fontBoldTextTd/text()").to_s
        val = blocks[index].css(".fontBoldTextTd ~ *").to_s
        temp_json[key] = val
      elsif blocks[index].name() == 'table'
        # puts blocks[index]
        # parse table to hash of arrays
      end
      @json[block_title] = temp_json
      # puts "-------------------------------------------------------------"
      # @json[key.text()] = ....
    end

    @json.each do |key, value|
      puts "#{key} is #{value}"
      puts "-------------------------------------------------------------"
    end

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
    arr = main_block[0].css("table#notice-documents") # <table id="notice-documents">

    result = Array.new

    arr.each do |elem|
      elem.css("a").each{ |el| result << el if el["href"] =~ /filestor/}
    end


    result.each do |elem|

      # puts elem["href"]
      puts "-------------------------------------------------------------"
      
      name = elem["href"].scan(/.+=(\w*)$/).first.first
      # puts path_to_save


      doc = DocLoader.new(name)
      d = doc.load_file

      File.open("F:\\www\\zakupki\\" + name + ".doc", "wb") do |f|
        f.write d.parsed_response
      end
    end
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