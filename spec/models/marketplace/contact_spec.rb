require "spec_helper"

describe Marketplace::Contact do
  it { should have_fields(:person, :phone, :email, :fax) }
  it { should be_embedded_in(:auth_organization) }
  it { should be_embedded_in(:customer) }
end
