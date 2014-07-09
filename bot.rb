require_relative "list_parser"
require_relative "list_loader"
require_relative "order_loader"
require_relative "order_parser"
require_relative "lib"

# obj = ListParser.new
# ids = Array.new
# ids = obj.get_ids("03.07.2014", "03.07.2014")

# unless ids.empty?
# ids.each do |hash|
#   case hash[:type] # create and use factory
#     when "usual"
#       obj = OrderLoader.new(hash[:id])
#       info_page = obj.info
#       parser = OrderParser.new
#       @json = Hash.new

#     when "solo"
#       obj = OrderSoloLoader.new(hash[:id])
#       info_page = obj.info
#   end
# end

obj = OrderLoader.new("0347100011914000035")
# info_page = obj.info
# puts info_page
parser = OrderParser.new
# parser.get_info(info_page)

# docs_page = obj.docs
# parser.get_docs(docs_page)

info_page = obj.info
parser.get_info(info_page)