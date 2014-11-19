require "bunny"
require "byebug"

#module Marketplace
#  class Bot::Workers::Worker
#    def run()
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      x = ch.topic("load_list")
      q = ch.queue("load_list", :exclusive => true)

      q.bind(x, :routing_key => "load_list")
     # byebug      
      begin
        q.subscribe(:block => true) do |delivery_info, properties, body|
          puts "subscribe"         
         # byebug
          puts "#{delivery_info.routing_key}:#{body}"         
        end
      rescue Interrupt => _
        ch.close
        conn.close
      end

#    end
#  end
#end
