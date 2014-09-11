module Marketplace
  class OrderParserXml
    def initialize
      @order_json = Hash.new
      @auth_organization_json = Hash.new
      @contacts_json = Hash.new
      @customer_json = Hash.new
    end
  end
end