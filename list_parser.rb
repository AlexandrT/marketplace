class ListParser

  # получаем id закупок со страницы с их списком за указанные даты
  def get_ids(start_date, end_date)
    # результат - массив ссылок на закупки
    orders_id = Array.new

    i = 0

    begin
      # TODO
      # с рандомом получше что-то придумать
      sleep Random.rand(30)
      i += 1
      page_num = i.to_s

      # грузим страницу списка
      source = ListLoader.new()
      page = Nokogiri::HTML(source.list(start_date, end_date, page_num), nil, 'utf-8')

      # собираем со страницы ссылки на страницы закупок
      page.css(".descriptTenderTd dl dt a").each{|link| orders_id << link["href"]}
    # продолжаем, пока на странице есть стрелка, указывающая на следующую страницу списка
    end while page.at_css(".rightArrow")

    # возвращаем массив ссылок на закупки
    return orders_id
  end
end
