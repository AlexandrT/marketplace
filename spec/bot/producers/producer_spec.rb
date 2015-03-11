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


  context "check_date" do
    it { expect(producer.send(:check_date, "04.09.2012")).to_not eq(false) }
    it { expect(producer.send(:check_date, "51.04.2031")).to eq(false) }
    it { expect(producer.check_date("111.04.2031")).to eq(false)}
  end
  end
end
