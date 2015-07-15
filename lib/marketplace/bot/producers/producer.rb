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

    # Отправляет задание на парсинг списка закупок с _:routing_key = "type.list.parse"_ в точку доступа
    # @param body [String] Строка с html загруженной страницы
    # @param start_price [Integer] Начальная стоимость закупки
    # @param end_price [Integer] Конечная стоимость закупки
    # @example
    #   parse_list("<html></html>", 0, 200000)
    def send_job(job_params, &block)
      begin
        payload = job_params.to_s
      
        self.x.publish(payload, key: block.call(job_params))
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
  end
end