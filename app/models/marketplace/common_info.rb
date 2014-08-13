module Marketplace
  class OrderInfo
    class CommonInfo
      include Mongoid::Document

      field :type
      field :platform_name
      field :platform_address
      field :customer_name
      field :step
      field :relation_with_plan
      embedded_in :order_info
    end
  end
end