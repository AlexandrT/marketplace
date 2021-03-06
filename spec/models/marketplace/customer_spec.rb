require "spec_helper"

describe Marketplace::Customer do
  it { should have_fields(:name, :bik, :ls_number, :rs_number, :real_address, :post_address) }
  it { should embed_one(:contact) }
  it { should be_embedded_in(:lot) }
end
