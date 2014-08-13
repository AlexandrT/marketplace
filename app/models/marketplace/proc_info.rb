module Marketplace
  class OrderInfo
    class ProcInfo
      include Mongoid::Document

      field :start_date
      field :end_date
      field :place
      field :order
      field :first_part_end_date
      field :auction_date
      field :auction_time
      field :additional_info
      embedded_in :order_info
    end
  end
end