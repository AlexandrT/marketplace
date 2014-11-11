require "bunny"

module Marketplace
  class Bot::Workers::Worker
    def run()
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      x = ch.topic("load_list")
      q = ch.queue("", :exclusive => true)

      q.bind(x, :routing_key => "list")
      
      begin
        q.subscribe(:block => true) do |delivery_info, properties, body|
          puts "#{routing_key}:#{body}"
          
          case type
          when "44_fz"
          when "94_fz"
          when "223_fz"
          else
            puts "unknown parser's type"
          end
          
        end
      rescue Interrupt => _
        ch.close
        conn.close
      end

    end
  end
end