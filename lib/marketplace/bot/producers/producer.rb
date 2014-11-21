require 'bunny'
require 'mongoid'
require 'byebug'

module Marketplace
  class Bot::Producers::Producer
    def initialize
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      @x = ch.topic("common")
    end

    def load_list(types, start_date, end_date, page_num)
    
    types.each do |type|
        begin
          
          msg = Hash.new 
          msg[:type] = type
          msg[:start_date] = start_date
          msg[:end_date] = end_date
          msg[:page_num] = page_num

          payload = msg.to_s

          @x.publish(payload, :routing_key => "#{type}.list")

          puts " [@x] Sent #{type}:#{payload}"

          current_download = Download.new(order_type: type, start_date: start_date, end_date: end_date)
          current_download.save
        rescue Exception => e
          puts e.message
        end
      end 
    end

    def parse_list(type, body)
      payload = body

      @x.publish(payload, :routing_key => "#{type}.list")
    end
  end
end