require 'bunny'
require 'mongoid'
require 'byebug'
require 'bot'

module Marketplace
  class Bot::Producers::Producer
    include Singleton

    # Точка доступа для заданий на загрузку и парсинг
    attr_accessor :x

    # Точка доступа для заданий на запись в БД
    attr_accessor :db_x

    # Проверяет дату на соответствие формату и валидность
    # @param input_date [String] Дата в формате _dd.mm.yyyy_
    # @return [Boolean]
    # @example
    #   check_date("11.11.2014")
    def check_date(input_date)
      if input_date.match(/^\d{2}\.\d{2}\.\d{4}$/)
        begin
          Date.parse(input_date)
        rescue ArgumentError
          puts "can't parse date"
          return false
        end
      else
        puts "wrong format"
        return false
      end
    end

    # Отправляет задание на загрузку списка закупок с _:routing_key = "type.list.load"_ в точку доступа
    # @param start_price [Integer] Начальная стоимость закупки
    # @param end_price [Integer] Конечная стоимость закупки
    # @example
    #   load_list(0б 200000)
    def load_list(search_params)

        begin
          payload = search_params.to_s

          self.x.publish(payload, :key => "#{search_params[:type]}.list.load")

        rescue Exception => e
          puts e.message
        end
      # end 
    end

    # Отправляет задание на парсинг списка закупок с _:routing_key = "type.list.parse"_ в точку доступа
    # @param body [String] Строка с html загруженной страницы
    # @param start_price [Integer] Начальная стоимость закупки
    # @param end_price [Integer] Конечная стоимость закупки
    # @example
    #   parse_list("<html></html>", 0, 200000)
    def parse_list(order_params)
      begin
        payload = order_params.to_s

        self.x.publish(payload, :key => "#{order_params[:type]}.list.parse")
      rescue Exception => e
        puts e.message
      end
    end

    # Отправляет задание на загрузку страницы с закупкой с _:routing_key = "type.order.load"_ в точку доступа
    # @param order_id [String] _id_ закупки, которую надо загрузить
    # @example
    #   load_order("345767215677")
    def load_order(order_params)
      begin
        payload = order_params.to_s

        self.x.publish(payload, :key => "#{order_params[:type]}.order.load")
      rescue Exception => e
        puts e.message
      end
    end

    # Отправляет задание на парсинг страницы с закупкой с _:routing_key = "type.order.parse"_ в точку доступа
    # @param body [String] Страница закупки
    # @example
    #   parse_order("<html> </html>")
    def parse_order(body)
      begin
        msg = Hash.new
        msg[:type] = @type
        msg[:page] = body

        payload = msg

        self.x.publish(payload, :key => "#{type}.order.parse")

        puts " [@x] Sent #{type}.order.parse"
      rescue Exception => e
        puts e.message
      end
    end

    # Создает подключения к точкам доступа
    # @example
    #   create_exchange
    def create_exchange
      conn = Bunny.new(:host => "localhost", :vhost => "/", :user => "amigo", :password => "42Amigo_Rabbit")
      conn.start
      ch = conn.create_channel
      self.x = ch.topic("common")

      db_conn = Bunny.new(:host => "localhost", :vhost => "/", :user => "amigo", :password => "42Amigo_Rabbit")
      db_conn.start
      db_channel = db_conn.create_channel
      self.db_x = ch.fanout("writer")
    end

    # Задает значения полей класса
    # @param type [String] Тип закупки
    # @param start_date [String] Начальная дата создания/обновления закупки
    # @param end_date [String] Конечная дата создания/обновления закупки
    # @param page_number [Integer] Номер текущей страницы списка закупок
    # @example
    #   fill_attr("fz_44", "11.11.2014", "11.11.2014", 0)
    def fill_attr(type, start_date = Date.today.strftime('%d.%m.%Y'), end_date = Date.today.strftime('%d.%m.%Y'), page_number = 0)
      @type = type
      @start_date = start_date
      @end_date = end_date
      @page_number = page_number + 1
    end

    # def initialize
      # create("fz_94")
    # end

    # Отправляет задание на сохранение json в бд
    # @param json [Json] Json с информацией о закупке
    # @example
    #   load_to_db(json)
    def load_to_db(json)
      begin
        self.db_x.publish(json)
      rescue Exception => e
        puts e.message
      end
    end

    # Увеличивает номер текущей страницы в контексте продюсера на 1
    # @param inc [Fixnum] на сколько увеличиваем (оно вроде всегда 1)
    # @example
    #   increment_page_number(1)
    def increment_page_number(inc)
      begin
        inc += 0
        @page_number += inc
      rescue Interrupt => _
        puts "inc is not Numeric"
      end
    end
  end
end