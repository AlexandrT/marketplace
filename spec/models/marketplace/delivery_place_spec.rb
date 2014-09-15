require "spec_helper"

describe Marketplace::DeliveryPlace do
  it { should have_field(:address) }
  it { should be_embedded_in(:lot) }
end
