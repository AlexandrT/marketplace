require 'bunny'
require 'mongoid'
require 'byebug'

#module Marketplace
#  class Bot::Producers::Producer
#    def initialize
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      @x = ch.topic("load_list")
##      q = ch.queue("load_list", :exclusive => true)
##      q.bind(@x, :routing_key => "list.load")
      
#    end

#    def create_tasks(types, start_date, end_date)
      start_date = "11.11.2014"
      end_date = "11.11.2014"
      types = ["fz44", "fz94"]
      types.each do |type|
        begin
          
          msg = Hash.new 
          msg[:type] = type
          msg[:start_date] = start_date
##          byebug
          msg[:end_date] = end_date

          payload = msg.to_s
          @x.publish(payload, :routing_key => "load_list")

        #  byebug

          puts " [@x] Sent #{type}:#{payload}"

        #  current_download = Download.new(order_type: type, start_date: start_date, end_date: end_date)
        #  current_download.save
        rescue Exception => e
          puts e.message
        end
      end

#     # conn.close
     
#    end
#  end
#end
