class OrderParser
  
  def initialize
    @json = Hash.new
  end

  def get_info2(info_page)
    page = Nokogiri::HTML(clean_trash(info_page), nil, 'utf-8')

    # получаем содержимое дива div class="noticeTabBoxWrapper"
    blocks = page.xpath('//div[@class="noticeTabBoxWrapper"]/child::*')

    # ключ в хэше @json 
    common_key = String.new
    
    # ключ во вложенном хэше
    key = String.new
    
    # значение во вложенном хэше
    val = Array.new

    # вложенный хэш
    embedded_json = Hash.new

    # хэш для вложенной таблицы
    nested_table = Hash.new

    # массив строк значений из вложенной таблицы
    inner_rows = Array.new

    # обходим все блоки, выбирая table и h2 для парсинга
    blocks.each do |block|
      # если блок h2
      if block.name == "h2"
        # и это не первая итерация (он не равен пустой строке), значит и embedded_json уже наполнен - складываем в @json.
        unless common_key == ""
          @json[common_key] = embedded_json.dup
          embedded_json.clear
        end
        common_key = block.inner_text().to_s
      # если блок table, то парсим его  
      elsif block.name == "table"
        # проверяем, есть ли предыдущий элемент
        unless block.previous_element.nil?
          prev_sibling = block.previous_element.name 
        end

        # если предыдущий эдемент тоже table
        if prev_sibling == "table"
          # то парсим текущий как вложенную таблицу
          th_tags = block.xpath(".//tr/th").text
          # получаем хэдеры вложенной таблицы
          nested_table['headers'] = th_tags

          tr_tags = block.xpath(".//tr[not(child::th)]")

          # получаем значения строк вложенной таблицы
          tr_tags.each do |tr_tag|
            td_tags = tr_tag.xpath(".//td[not(@class)]").text
            inner_rows << td_tags
          end

          nested_table['rows'] = inner_rows

          # парсим последнюю строку, содержащую "Итого:"
          key = block.css(".fontBoldTextTd/text()")[0].to_s
          val = block.css(".fontBoldTextTd ~ *").to_s
          val = clean_trash(val)
          nested_table[key] = val

          embedded_json["embedded_table"] = nested_table.dup
          nested_table.clear
        # парсим как одиночную таблицу
        else
          tr_tags = block.css("tr")
          
          tr_tags.each do |tr_tag|
            key = tr_tag.css(".fontBoldTextTd/text()")[0].to_s
            val = tr_tag.css(".fontBoldTextTd ~ *")
            # val = clean_trash(val)
            embedded_json[key] = val

            # запускаем парсинг компании, если ссылка на ее страницу
            company_exists = false
            company_exists = val.inner_html.include? "/organization/"
              
            if company_exists
              organization_url = val[0].xpath('//a[contains(@href, "/organization/")]').to_a
              company_url = clean_trash(organization_url[0]["href"].to_s)
                
              company = CompanyLoader.new
              company_page = company.get_page(company_url)
              company_parser = CompanyParser.new
              company_parser.get(company_page)
            end
            embedded_json[key] = val
          end
        end
      end
    end

    # добавляем в хэш результат последней итерации
    @json[common_key] = embedded_json.dup

    # парсим div display:none
    main_td = page.xpath("//div[@class='expandRow']//td[*]")[0]

    # table и h2 из div display:none
    elements = main_td.children

    # вложенный хэш для подразделов
    json_hide_embedded = Hash.new

    # ключ для подразделов div display:none
    key_hide = String.new

    # ключ в @json для div display:none
    common_hide_key = String.new

    # вложенный хэш для div display:none
    json_hide = Hash.new

    elements.each do |element|
      if element.name == "table"
        tr_tags = element.css("tr")

        # парсим строки из таблички
        tr_tags.each do |tr_tag|
          key = tr_tag.css(".fontBoldTextTd/text()")[0].to_s
          val = tr_tag.css(".fontBoldTextTd ~ *").to_s
          
          # если <td> со значением нет
          if val.nil?
            val = ""
          end

          # если у таблички нет предшествующего h2, то складываем все сразу во вложенный хэш
          if key_hide == ""
            json_hide[key] = val
          # иначе во вложенный хэш json_hide_embedded
          else  
           json_hide_embedded[key] = val
          end
        end

        # складываем результат парсинга во вложенный хэш
        json_hide[key_hide] = json_hide_embedded.dup
        json_hide_embedded.clear
      elsif element.name == "h2"
        # парсим ключ для @json
        key_hide = element.inner_text().to_s
      end
    end

    # ключ в @json div display:none
    common_hide_key = page.xpath("//div[@class='expandRow']")[0].previous_element.text
    # помещаем в @json результат парсинга div display:none
    @json[common_hide_key] = json_hide.dup
    json_hide.clear

    @json.each do |elem|
      puts elem
      puts "---------------------------------------------------------------------------------"
    end

  end

  def get_info(info_page)
    page = Nokogiri::HTML(info_page, nil, 'utf-8')
    main_block = page.css("div.noticeTabBox")
    
    # //h2[following-sibling::table and parent::div[@class='noticeTabBoxWrapper']] - все h2 кроме последнего блока
    # //table[preceding-sibling::h2 and parent::div[@class='noticeTabBoxWrapper']] - все таблицы после h2 кроме последнего блока
    blocks_title = main_block[0].xpath("//h2[following-sibling::table and parent::div[@class='noticeTabBoxWrapper']]").to_a
    blocks = main_block[0].xpath("//table[preceding-sibling::h2 and parent::div[@class='noticeTabBoxWrapper']]").to_a
    
    check_table = false

    file = File.new("parser.log", "w")

    # Составляем новый массив из //table[preceding-sibling::h2]
    # если за <table> следует еще один такой же тег, то слепляем их в один, дабы получить правильный хэш { h2: {table} }
    temp_arr = Array.new
    temp_json = Hash.new

    blocks_title.each_with_index do |block_title, index|
      unless check_table
        if blocks[index].next_element().name == "table"
          tmp = block_title.to_s + block_title.next_element.to_s
          check_table = true
        else
          tr_tags = blocks[index].css("tr")
          tr_tags.each_with_index do |tr_tag, i|
            key = tr_tag.css(".fontBoldTextTd/text()")[0]
            val = tr_tag.css(".fontBoldTextTd ~ *").to_a

            org = Array.new
            org = val[0].inner_html.include? "/organization/"
            
            if org
              organization_url = val[0].xpath('//a[contains(@href, "/organization/")]').to_a
              company_url = clean_trash(organization_url[0]["href"].to_s)
              
              company = CompanyLoader.new
              company_page = company.get_page(company_url)
              company_parser = CompanyParser.new
              company_parser.get(company_page)
            end
            temp_json[key] = val
          end
        end
        temp_arr << tmp
      else
        check_table = false
      end
    end

        # if blocks[index].name() == 'table'
          # puts block_title.text()
          # puts "if"

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

    # temp_arr.each do |arr_elem|
      # puts arr_elem
      # puts "-------------------------------------------------------------------"
    # end

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
