module Marketplace
  class Lot
    include Mongoid::Document

    field :okdp
    field :okved
    field :measure
    field :count
    field :price
    field :additional_info

    embedded_in :order
  end
end