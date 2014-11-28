module Marketplace
  class Bot::Parsers::Base

    # Создает хэши, используемые при парсинге закупок в дочерних методах
    # @example
    #   new()
    def initialize
      @order_json = Hash.new
      @order_json = {lots:[]}
      
      @auth_organization_json = Hash.new
      @contacts_json = Hash.new
      @customer_json = Hash.new

      # жсон с отдельным лотом. после наполнения сливаем его в массив лотов
      @lot_json = Hash.new
    end

    # Запускает парсинг документа - наполняет хэш **@order_json** и все вложенные хэши
    # @param page [String] Страница закупки для парсинга
    # @example
    #   run("<html>test</html>")
    def run(page)
      fill_json(page)
    end
  end
end