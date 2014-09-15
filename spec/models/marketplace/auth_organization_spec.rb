require "spec_helper"

describe Marketplace::AuthOrganization do
  it { should have_fields(:full_name, :short_name, :inn, :kpp, :ogrn, :address, :post_address, :okato) }
  it { should embed_one(:contact) }
  it { should be_embedded_in(:order) }
end
