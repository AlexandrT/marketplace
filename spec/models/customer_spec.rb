require "spec_helper"

describe Customer do
  it { should have_fields(:name, :bik, :ls_number, :rs_number, :real_address, :post_address) }
  it { should have_one(:contact) }
  it { should be_embedded_in(:lot) }
end