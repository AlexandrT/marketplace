require "bunny"

module Marketplace
  class Bot::Workers::LoadWorker
    def run()
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      x = ch.topic("common")
      q = ch.queue("load", :exclusive => true)

      q.bind(x, :routing_key => "*.*")
      
      begin
        q.subscribe(:block => true) do |delivery_info, properties, body|
          type, obj = delivery_info.routing_key.split(".")
          start_date = body.start_date
          end_date = body.end_date
          puts "#{delivery_info.routing_key}:#{body}"   

          if obj == "list"
            ListLoader.list(type, start_date, end_date, 0)
          elsif obj == "order"
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