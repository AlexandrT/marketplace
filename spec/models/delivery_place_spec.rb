require "spec_helper"

describe DeliveryPlace do
  it { should have_fields(:address) }
  it { should be_embedded_in(:lot) }
end