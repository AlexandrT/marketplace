require "spec_helper"

describe Marketplace::Order do
  it { should have_fields(:remote_id, :type, :name) }
  it { should have_one :auth_organization }
  it { should have_many :lots }
end
