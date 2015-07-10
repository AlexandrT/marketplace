require "bunny"
require "bot"

module Marketplace
  class Bot::Workers::LoadWorker

    # Создает очередь **load** и начинает слушать ее. Забирает сообщения, _:routing_key_ которых заканчивается на **.load**
    # @example
    #   run()
    def run
      conn = Bunny.new(:host => "localhost", :vhost => "/", :user => "amigo", :password => "42Amigo_Rabbit")
      conn.start

      ch = conn.create_channel
      x = ch.topic("common")
      q = ch.queue("load", :exclusive => true)

      q.bind(x, :routing_key => "#.load")
      
      begin
        q.subscribe(:block => true) do |delivery_info, properties, body|
          type, obj = delivery_info.routing_key.split(".")

          parsed_str = JSON.parse(body)

          if obj == "list"
            page_loader = PageLoader.new
            page_loader.load_list(parsed_str[:start_price], parsed_str[:end_price], parsed_str[:type])
          elsif obj == "order"
            page_loader = PageLoader.new
            page_loader.load_order(parsed_str[:order_id])
          else
            puts "unknown object"
          end
        end
      rescue Interrupt => _
        ch.close
        conn.close
      end

    end
  end
end