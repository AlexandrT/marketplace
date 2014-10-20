module Marketplace
  class Bot::Parsers::ParserFz44 < Bot::Parsers::OrderParserXml
    def fill_json(info_page)
      get_order_info(info_page)
      
      lot_table = info_page.xpath('//table[@class="table"]').first
      get_lots(lot_table)
    end

    def get_order_info(info_page)
      @order_json[:remote_id] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Номер извещения")]]/following-sibling::td/p/text()').text
      @order_json[:name] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Наименование объекта закупки")]]/following-sibling::td/p/text()').text
      @order_json[:type] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Способ определения поставщика")]]/following-sibling::td/p/text()').text
    end

    def get_customer(info_page)
    end

    def get_auth_organization(info_page)
      @auth_organization_json[:full_name] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Организация, осуществляющая закупку")]]/following-sibling::td/p/text()').text
      @auth_organization_json[:post_address] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Почтовый адрес")]]/following-sibling::td/p/text()').text
      @auth_organization_json[:address] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Место нахождения")]]/following-sibling::td/p/text()').text

      @contacts_json[:person] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Ответственное должностное лицо")]]/following-sibling::td/p/text()').text
      @contacts_json[:phone] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Номер контактного телефона")]]/following-sibling::td/p/text()').text
      @contacts_json[:email] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Адрес электронной почты")]]/following-sibling::td/p/text()').text
      @contacts_json[:fax] = info_page.xpath('//td[p[@class="parameter" and contains(.,"Факс")]]/following-sibling::td/p/text()').text

      @auth_organization_json[:contacts] = @contacts_json
    end

    def get_lots(lot_table)
      @lot_json[:currency] = lot_table.xpath('//td[@id="invis" and not(contains(., "Итого"))]').first.text
      total_sum = lot_table.xpath('//td[@id="invis" and contains(., "Итого")]').first.text
      @lot_json[:price] = total_sum.split(":")[1].strip
      
      tr_header_num = lot_table.xpath('count(//td[not(@colspan) and contains(., "Наименование товара, работ, услуг")]/../preceding-sibling::*)+1').to_i
      # сделать для этого отдельный метод. передавать туда текст в столбце и возвращать его номер
      td_name_num = lot_table.xpath('count(//td[not(@colspan) and contains(., "Наименование товара, работ, услуг")]/preceding-sibling::*)+1').to_i
      td_okpd_num = lot_table.xpath('count(//td[not(@colspan) and contains(., "Код по ОКПД")]/preceding-sibling::*)+1').to_i
      td_customer_num = lot_table.xpath('count(//td[not(@colspan) and contains(., "Заказчик")]/preceding-sibling::*)+1').to_i
      td_measure_num = lot_table.xpath('count(//td[not(@colspan) and contains(., "Единица измерения")]/preceding-sibling::*)+1').to_i
      td_count_num = lot_table.xpath('count(//td[not(@colspan) and contains(., "Количество")]/preceding-sibling::*)+1').to_i
      td_price_num = lot_table.xpath('count(//td[not(@colspan) and contains(., "Стоимость")]/preceding-sibling::*)+1').to_i

      rows = lot_table.xpath('.//tr[not(@id="invis")]')
      # byebug
    end
  end
end