require "spec_helper"
require "bot"

describe Marketplace::Bot::Producers::Producer do
  let(:producer) { Marketplace::Bot::Producers::Producer.new }
  let(:worker) { Marketplace::Bot::Workers::Worker.new }

  context "test rabbit" do
    xit "create task" do 
      producer.create_tasks(["fz94", "fz223"], "11.11.2014", "11.11.2014")
      worker.run
    end
  end
end
