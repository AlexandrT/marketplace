require "spec_helper"

describe Marketplace::LotItem do
  it { should have_fields(:okdp, :okved, :measure, :count, :additional_info, :delivery_place) }
  it { should be_embedded_in(:lot) }
end
