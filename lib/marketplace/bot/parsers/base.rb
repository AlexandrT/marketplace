module Marketplace
  class Bot::Parsers::Base
    def initialize
      @order_json = Hash.new
      @order_json = {lots:[]}
      
      @auth_organization_json = Hash.new
      @contacts_json = Hash.new
      @customer_json = Hash.new

      # жсон с отдельным лотом. после наполнения сливаем его в массив лотов
      @lot_json = Hash.new
    end
  end
end