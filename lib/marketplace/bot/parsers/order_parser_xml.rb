module Marketplace
  class OrderParserXml
    def initialize
      @order_json = Hash.new
      @organization_json = Hash.new
      @contacts_json = Hash.new
      @customer = Hash.new
    end
  end
end