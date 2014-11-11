require 'bunny'
require 'mongoid'

module Marketplace
  class Bot::Producers::Producer
    def create_tasks(types, start_date, end_date)
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      x = ch.fanout("load_list")

      types.each do |type|
        msg = "#{type} #{start_date} #{end_date}"
        x.publish(msg)

        current_download = Download.new
        current_download.write_attributes(order_type: type, start_date: start_date, end_date: end_date)
      end

      conn.close
     
    end
  end
end