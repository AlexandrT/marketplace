require 'bunny'
require 'mongoid'
require 'byebug'

module Marketplace
  class Bot::Producers::Producer
    include Singleton

    attr_accessor :type
    attr_accessor :start_date
    attr_accessor :end_date
    attr_accessor :page_number
    attr_accessor :order_id

    def initialize(type, start_date, end_date, page_number)
      @type = type
      @start_date = start_date
      @end_date = end_date
      @page_number = 1

      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      @x = ch.topic("common")
    end

    # Проверяет дату на соответствие формату и валидность
    # @param input_date [String] дата в формате dd.mm.yyyy
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

    # Отправляет задание на загрузку списка закупок с :routing_key = "type.list.load" в точку доступа
    # @param type [String] тип закупки
    # @param start_date [String] начальная дата создания/обновления закупки
    # @param end_date [String] конечная дата создания/обновления закупки
    # @param page_num [Integer] номер загружаемой страницы
    # @example
    #   load_list("fz44", "09.21.2014", "09.22.2014", 4)
    def load_list(start_price, end_price)
      if check_date(@start_date) and check_date(@end_date)
        begin
          msg = Hash.new 
          msg[:type] = @type
          msg[:start_date] = @start_date
          msg[:end_date] = @end_date
          msg[:page_num] = @page_num
          msg[:start_price] = start_price
          msg[:end_price] = end_price

          payload = msg.to_s

          @x.publish(payload, :routing_key => "#{@type}.list.load")

          puts " [@x] Sent #{type}:#{payload}"

          # current_download = Download.new(order_type: @type, start_date: @start_date, end_date: @end_date)
          # current_download.save
        rescue Exception => e
          puts e.message
        end
      end 
    end

    # Отправляет задание на парсинг списка закупок с :routing_key = "type.list.parse" в точку доступа
    # @param body [String] строка с html загруженной страницы
    def parse_list(body, start_price, end_price)
      begin
        msg = Hash.new
        msg[:type] = @type
        msg[:start_date] = @start_date
        msg[:end_date] = @end_date
        msg[:page_num] = @page_num
        msg[:start_price] = @start_price
        msg[:end_price] = @end_price
        msg[:page] = body

        payload = msg.to_s

        @x.publish(payload, :routing_key => "#{@type}.list.parse")

        puts " [@x] Sent #{type}.list.parse"
      rescue Exception => e
        puts e.message
      end
    end

    def load_order(order_id)
      order_id ||= @order_id
      begin
        msg[:type] = @type
        msg[:order_id] = order_id

        payload = msg.to_s

        @x.publish(payload, :routing_key => "#{@type}.order.load")

        puts " [@x] Sent #{type}.order.load"
      rescue Exception => e
        puts e.message
      end
    end

    def parse_order(body)
      begin
        msg[:type] = @type
        msg[:page] = body

        payload=msg.to_s

        @x.publish(payload, :routing_key => "#{type}.order.parse")

        puts " [@x] Sent #{type}.order.parse"
      rescue Exception => e
        puts e.message
      end
    end
  end
end