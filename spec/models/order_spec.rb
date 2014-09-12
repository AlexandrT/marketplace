require "spec_helper"

describe Order do
  it { should have_fields(:remote_id, :type, :name) }
  it { should have_one :auth_organization }
  it { should have_many :lots }
end