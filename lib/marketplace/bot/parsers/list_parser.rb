require 'nokogiri'

class ListParser

  def get_ids(start_date, end_date)
    orders_id = []
    i = 0
    begin
      sleep Random.rand(30)
      i += 1
      page_num = i.to_s

      source = ListLoader.new()  # date?
      page = Nokogiri::HTML(source.list(start_date, end_date, page_num), nil, 'utf-8')
      if i > 3
        return orders_id
      end
      page.css(".descriptTenderTd dl dt a").each{|link| orders_id << link["href"]}
    end while page.at_css(".rightArrow")
    return orders_id
  end
end
