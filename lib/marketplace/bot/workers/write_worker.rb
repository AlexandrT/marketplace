require "bunny"

module Marketplace
  class Bot::Workers::WriteWorker

    # Создает очередь **write** и начинает слушать ее.
    # @example
    #   run()
    def run
      conn = Bunny.new(:host => "localhost", :vhost => "/", :user => "amigo", :password => "42Amigo_Rabbit")
      conn.start

      ch = conn.create_channel
      x = ch.fanout("writew")
      q = ch.queue("", :exclusive => true)

      q.bind(x)
      
      begin
        q.subscribe(:block => true) do |delivery_info, properties, body|
          writer = Writer.new
          writer.to_db(body)
        end
      rescue Interrupt => _
        ch.close
        conn.close
      end

    end
  end
end