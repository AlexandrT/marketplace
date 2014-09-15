require "spec_helper"

describe Marketplace::Order do
  it { should have_fields(:remote_id, :type, :name) }
  it { should embed_one :auth_organization }
  it { should embed_many :lots }
end
