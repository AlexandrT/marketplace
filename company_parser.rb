# encoding: UTF-8

class CompanyParser
  def initialize
    @json_company = Hash.new
  end

  def get(company_page)
    page = Nokogiri::HTML(company_page, nil, 'utf-8')

    # получаем блок с нужным контентом
    main_block = page.xpath('//td[@class="icePnlGrdCol mainPageCol paddL10 paddR10"]')

    # NodeSet ключей хэша
    tags_td = main_block[0].xpath('.//td[@class="iceOutLbl"]')

    # является ли элемент вложенным
    embedded_flag = false

    # вложенный хэш
    json_embedded = Hash.new

    # ключ предыдущей итерации для невложенного значения.
    # если распарсили вложенные значения, то сохраняться все в @json_company будет именно с помощью этого ключа 
    last_key = String.new

    tags_td.each do |tag_td|
      # если указанного атрибута нет, то тег не является вложенным
      unless tag_td.get_attribute('style') == 'padding-left:10px'
        
        # если флаг установлен, то надо сохранять результат в @json_company
        if embedded_flag
          @json_company[last_key] = json_embedded.dup
          embedded_flag = false
          json_embedded.clear
        end

        # сохраняем результат ключ:значение в @json_company
        key = tag_td.to_s
        val = tag_td.next_element().to_s
        @json_company[key] = val

        # устанавливаем значение last_key для следующей итерации
        last_key = key
      # style есть, вложенный хэш
      else
        # сохраняем во вложенный хэш
        key = tag_td.to_s
        val = tag_td.next_element().to_s
        json_embedded[key] = val

        # ставим флаг, чтобы при следующей итерации на невложенном значении сохранился вложенный хэш
        embedded_flag = true
      end
    end

    # если флаг установлен, то вложенный массив был последним в tag_td и еще не сохранялся
    if embedded_flag
      @json_company[last_key] = json_embedded.dup
      embedded_flag = false
      json_embedded.clear
    end

    @json_company.each do |elem|
      puts elem
      puts "==========================================================================="
    end
  end
end