module Marketplace
  class OrderInfo
    class ObjectInfo
      include Mongoid::Document

      field :restriction
      embeds_one :product_name
      embedded_in :order_info
    end
  end
end