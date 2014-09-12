require "spec_helper"

describe Contact do
  it { should have_fields(:person, :phone, :email, :fax) }
  it { should be_embedded_in(:auth_organization, :customer) }
end