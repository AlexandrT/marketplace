require "bunny"

module Marketplace
  class Bot::Workers::ParseWorker

    # Создает очередь **parse** и начинает слушать ее. Забирает сообщения, _:routing_key_ которых заканчивается на **.parse**
    # @example
    #   run()
    def run()
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      x = ch.topic("common")
      q = ch.queue("parse", :exclusive => true)

      q.bind(x, :routing_key => "#.parse")
      
      begin
        q.subscribe(:block => true) do |delivery_info, properties, body|
          type, obj = delivery_info.routing_key.split(".")
          puts "#{delivery_info.routing_key}:#{body}"   

          if obj == "list"
            list_parser = ListParser.new
            list_parser.get_ids(body.page, body.start_price, body.end_price)
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
            parser.run(body.page)
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