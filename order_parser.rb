class OrderParser
  
  def initialize
    @json_info = Hash.new
    @json_event = Hash.new
    @json_docs = Hash.new
  end

  def get_info2(info_page)
    page = Nokogiri::HTML(clean_trash(info_page), nil, 'utf-8')

    # получаем содержимое дива div class="noticeTabBoxWrapper"
    blocks = page.xpath('//div[@class="noticeTabBoxWrapper"]/child::*')

    # ключ в хэше @json_info
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
        # и это не первая итерация (он не равен пустой строке), значит и embedded_json уже наполнен - складываем в @json_info.
        unless common_key == ""
          @json_info[common_key] = embedded_json.dup
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
    @json_info[common_key] = embedded_json.dup

    # парсим div display:none
    main_td = page.xpath("//div[@class='expandRow']//td[*]")[0]

    # table и h2 из div display:none
    elements = main_td.children

    # вложенный хэш для подразделов
    json_hide_embedded = Hash.new

    # ключ для подразделов div display:none
    key_hide = String.new

    # ключ в @json_info для div display:none
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
        # парсим ключ для @json_info
        key_hide = element.inner_text
      end
    end

    # ключ в @json_info div display:none
    common_hide_key = page.xpath("//div[@class='expandRow']")[0].previous_element.text
    # помещаем в @json_info результат парсинга div display:none
    @json_info[common_hide_key] = json_hide.dup
    json_hide.clear

    @json_info.each do |elem|
      puts elem
      puts "---------------------------------------------------------------------------------"
    end
  end

  def get_docs2(docs_page)
    page = Nokogiri::HTML(docs_page, nil, 'utf-8')
    main_block = page.css("div.noticeTabBoxWrapper")

    blocks = main_block.children

    # вложенный массив для документов одного типа
    json_embedded = Hash.new

    blocks.each do |block|
      # ключ для @json_docs - тип документов
      common_key = String.new

      if block.name == "h2"
        common_key = block.inner_text
      elsif block.name == "table"
        # собираем все ссылки из таблицы
        links = block.css("a")
        arr.each do |a|
          # если в href ссылки содержится /filestor/, то это ссылка на документ
          if a["href"] =~ /filestor/
            # юзерфрендли имя документа
            key = a.text().to_s
            clean_trash(key)

            # ссылка на документ
            val = a["href"].to_s
            json_embedded[key] = val
          end
        end
      end

      @json_docs[common_key] = json_embedded
    end
  end

  def get_event(event_page)
    page = Nokogiri::HTML(event_page, nil, 'utf-8')

    # получаем табличку с нужным контентом
    main_block = page.css("table#event")

    # массив событий
    events = main_block[0].xpath(".//tbody/tr")

    events.each do |event|
      # дата события
      key = event.xpath("td[1]/text()").to_s
      clean_trash(key)
      
      # расшифровка события
      value = event.xpath("td[2]/text()").to_s
      clean_trash(value)
      @json_event[key] = value
    end

    @json_event.each do |key, value|
      puts "#{key} is #{value}"
      puts "-------------------------------------------------------------"
    end

  end
end
