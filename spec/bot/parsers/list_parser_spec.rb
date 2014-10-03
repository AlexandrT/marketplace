require "spec_helper"
require "bot"

describe Marketplace::Bot::Parsers::ListParser do
  let(:list_parser) { Marketplace::Bot::Parsers::ListParser.new }

  let(:start_date) { "04.09.2012" }
  let(:end_date) { "05.09.2012" }

  context "check_date" do
    it { expect(list_parser.send(:check_date, "04.09.2012")).to_not eq(false) }
    it { expect(list_parser.send(:check_date, "51.04.2031")).to eq(false) }
    it { expect(list_parser.check_date("111.04.2031")).to eq(false)}
  end

  context "get_ids" do
    # before(:each) do
    # 	doc = Nokogiri::HTML(open(Rails.root + '../../spec/support/fz_44.html'))
    #   # Nokogiri::HTML::Document.should_receive(:parse).and_return(doc)
    #   Nokogiri::HTML.stub(:open).and_return(doc)
    # end
  end
end
