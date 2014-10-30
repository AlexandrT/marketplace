require "bunny"

module Marketplace
  class Bot::Workers::Worker
    def run(type)
      conn = Bunny.new
      conn.start

      ch = conn.create_channel
      q = ch.queue("parser")

      case type
      when "list"
      when "44_fz"
      when "94_fz"
      when "223_fz"
      else
        puts "unknown parser's type"
      end
    end
  end
end