require "spec_helper"
require "bot"
require "moqueue"

describe Marketplace::Bot::Producers::Producer do
  let(:producer) { Marketplace::Bot::Producers::Producer.instance }
  # let(:worker) { Marketplace::Bot::Workers::Worker.new }

  context "test rabbit" do
    
    before(:each) do
      reset_broker
      producer.stub(:connect).and_return(mock_exchange(:topic => "common"))
    end

    it "load_list" do 
      producer.load_list(0, 1000)
      # worker.run
    end
  end


  context "check_date" do
    it { expect(producer.send(:check_date, "04.09.2012")).to_not eq(false) }
    it { expect(producer.send(:check_date, "51.04.2031")).to eq(false) }
    it { expect(producer.check_date("111.04.2031")).to eq(false)}
  end
end
