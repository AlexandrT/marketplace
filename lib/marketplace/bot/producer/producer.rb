require 'bunny'
require 'mongoid'

module Marketplace
  class Producer
    def initialize
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      q = ch.queue("", :exclusive => true)
      x = ch.fanout("load.list")

      q.bind(x)
    end
    
    def create_tasks
      
    end
  end
end