require "bunny"

module Marketplace
  class Bot::Workers::ParseWorker

    # Создает очередь **parse** и начинает слушать ее. Забирает сообщения, _:routing_key_ которых заканчивается на **.parse**
    # @example
    #   run()
    def run()
      conn = Bunny.new(:host => "localhost", :vhost => "/", :user => "amigo", :password => "42Amigo_Rabbit")
      conn.start

      ch = conn.create_channel
      x = ch.topic("common")
      q = ch.queue("parse", :exclusive => true)

      q.bind(x, :routing_key => "#.parse")
      
      begin
        q.subscribe(:block => true) do |delivery_info, properties, body|
          type, obj = delivery_info.routing_key.split(".")

          parsed_str = JSON.parse(body)

          if obj == "list"
            list_parser = ListParser.new
            list_parser.get_ids(parsed_str[:page], parsed_str[:start_price], parsed_str[:end_price])
          elsif obj == "order"
            case type
            when "fz_44"
              parser = ParserFz44.new
            when "fz_94"
              parser = ParserFz94.new
            when "fz_223"
              parser = ParserFz223.new
            else
              puts "unknown order type in parse_worker"
            end
            order_json = parser.run(parsed_str[:page])

            producer = Producer.instance
            producer.load_to_db(order_json)

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