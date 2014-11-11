module Marketplace
  class Download
    include Mongoid::Document

    field :start_date, type: DateTime
    field :end_date, type: DateTime
    field :result, type: Boolean, default: false
    field :order_type
    field :count, type: Integer
  end
end