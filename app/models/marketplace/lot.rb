module Marketplace
  class Lot
    include Mongoid::Document

    field :name
    field :currency
    field :price

    embedded_in :order
    embeds_many :lot_items
    embeds_one :delivery_place
  end
end