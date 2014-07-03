def split_array(arr)
  orders = []
  arr.each do |element|
    if element.include? "zakupki.gov.ru" #HOST
      # http://zakupki.gov.ru/223/purchase/public/purchase/info/common-info.html?noticeId=1239485&epz=true
      unified_element = element.scan(/.*noticeId=(\d+)&.*/).first.first
      orders << {id: unified_element, type: "solo"}
    else
      # /epz/order/notice/ea44/view/common-info.html?regNumber=0128200000114003315
      unified_element = element.scan(/.*regNumber=(\d+)$/).first.first
      orders << {id: unified_element, type: "usual"}
    end
  end
  return orders
end


def clean_trash(html)
  html.gsub!("\r", " ")
  html.gsub!("\n", " ")
  html.gsub!("\t", " ")
  html.gsub!("<br>", " ")
  html.strip!
  while html =~ /\s{2,}/
    html.gsub!("  ", " ")
  end
  return html
end