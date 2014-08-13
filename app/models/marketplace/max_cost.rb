module Marketplace
  class OrderInfo
    class MaxCost
      include Mongoid::Document

      field :max_cost
      field :currency
      field :payment
      field :source
      embedded_in :order_info
    end
  end
end