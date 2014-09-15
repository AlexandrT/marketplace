require "spec_helper"

describe Marketplace::Lot do
  it { should have_fields(:name, :currency, :price) }
  it { should embed_many(:lot_items) }
  it { should embed_one(:customer) }
  it { should embed_one(:delivery_place) }
  it { should be_embedded_in(:order) }
end
