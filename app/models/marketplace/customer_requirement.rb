module Marketplace
  class OrderInfo
    class CustomerRequirement
      include Mongoid::Document

      field :relation_with_plan
      field :max_cost
      field :place_of_delivery
      field :time_of_delivery
      embeds_one :procuring
      embeds_one :contract_procuring
      embedded_in :order_info
    end
  end
end