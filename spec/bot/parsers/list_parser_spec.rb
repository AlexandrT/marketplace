require "spec_helper"
require "bot"

describe Marketplace::Bot::Parsers::ListParser do
  let( :list_parser ) { Bot::Parsers::ListParser.new }

  let( :valid_date ) { "04.09.2012" }
  let( :invalid_time ) { "51.04.2031" }
  let( :wrong_format_time ) { "111.04.2031" }

  it { expect{list_parser.check_date(valid_date)}.should_not be_false }
  it { expect{list_parser.check_date(invalid_time)}.to raise_error ArgumentError }
  it { expect{list_parser.check_date(wrong_format_time)}.should be_false }
end