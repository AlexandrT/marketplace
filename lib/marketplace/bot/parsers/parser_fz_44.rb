module Marketplace
  class Bot::Parsers::ParserFz44 < Bot::Parsers::Base
    def fill_json(info_page)
      get_order_info(info_page)
      
      lot_table = info_page.xpath('//table[@class="table"]').first
      get_lots(lot_table)
    end

    def get_order_info(info_page)
      @order_json[:remote_id] = get_content(info_page, 'Номер извещения')
      @order_json[:name] = get_content(info_page, 'Наименование объекта закупки')
      @order_json[:type] = get_content(info_page, 'Способ определения поставщика')
    end

    def get_customer(info_page)
    end

    def get_auth_organization(info_page)
      @auth_organization_json[:full_name] = get_content(info_page, 'Организация, осуществляющая закупку')
      @auth_organization_json[:post_address] = get_content(info_page, 'Почтовый адрес')
      @auth_organization_json[:address] = get_content(info_page, 'Место нахождения')

      @contacts_json[:person] = get_content(info_page, 'Ответственное должностное лицо')
      @contacts_json[:phone] = get_content(info_page, 'Номер контактного телефона')
      @contacts_json[:email] = get_content(info_page, 'Адрес электронной почты')
      @contacts_json[:fax] = get_content(info_page, 'Факс')

      @auth_organization_json[:contacts] = @contacts_json
    end

    def get_lots(lot_table)
      @lot_json[:currency] = lot_table.xpath('//td[@id="invis" and not(contains(., "Итого"))]').first.text
      total_sum = lot_table.xpath('//td[@id="invis" and contains(., "Итого")]').first.text
      @lot_json[:price] = total_sum.split(":")[1].strip
      
      tr_header_num = lot_table.xpath('count(//td[not(@colspan) and contains(., "Наименование товара, работ, услуг")]/../preceding-sibling::*)+1').to_i
      
      td_name_num = get_table_content(lot_table, 'Наименование товара, работ, услуг')
      td_okpd_num = get_table_content(lot_table, 'Код по ОКПД')
      td_customer_num = get_table_content(lot_table, 'Заказчик')
      td_measure_num = get_table_content(lot_table, 'Единица измерения')
      td_count_num = get_table_content(lot_table, 'Количество')
      td_price_num = get_table_content(lot_table, 'Стоимость')

      rows = lot_table.xpath('.//tr[not(@id="invis")]')
    end

    def get_content(html, contains_str)
      html.xpath('//td[p[@class="parameter" and contains(.,"' + contains_str + '")]]/following-sibling::td/p/text()').first.text
      # html.xpath('//td[p[@class="parameter" and contains(.,"#{contains_str}")]]/following-sibling::td/p/text()').first.text
    end

    def get_table_content(table_html, header)
      table_html.xpath('count(//td[not(@colspan) and contains(., "' + header + '")]/preceding-sibling::*)+1').to_i
    end
  end
end