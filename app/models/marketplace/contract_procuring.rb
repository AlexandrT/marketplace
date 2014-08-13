module Marketplace
  class CustomerRequirement
    class ContractProcuring
      include Mongoid::Document

      field :requirement
      field :size
      field :order
      field :details
      embedded_in :customer_requirement
    end
  end
end