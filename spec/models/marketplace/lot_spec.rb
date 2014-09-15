require "spec_helper"

describe Marketplace::Lot do
  it { should have_fields(:name, :currency, :price) }
  it { should have_many(:lot_items) }
  it { should have_one(:delivery_place, :customer) }
  it { shoul be_embedded_in(:order) }
end
