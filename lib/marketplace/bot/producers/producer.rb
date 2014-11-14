require 'bunny'
require 'mongoid'

module Marketplace
  class Bot::Producers::Producer
    def initialize
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      x = ch.topic("load_list")
      
    end

    def create_tasks(types, start_date, end_date)
      types.each do |type|
        begin
          
          msg = Hash.new 
          msg[:type] = type
          msg[:start_date] = start_date
          byebug
          msg[:end_date] = end_date

          payload = msg.as_json
          x.publish(payload, :routing_key => "list")

          current_download = Download.new(order_type: type, start_date: start_date, end_date: end_date)
          current_download.save
        rescue Exception => e
          puts e.message
        end
      end

      conn.close
     
    end
  end
end