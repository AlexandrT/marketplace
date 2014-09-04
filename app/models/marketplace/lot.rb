module Marketplace
  class Lot
    include Mongoid::Document

    field :name
    field :okdp
    field :okved
    field :measure
    field :count
    field :price
    field :currency
    field :additional_info

    embedded_in :order
    embeds_one :delivery_place
  end
end