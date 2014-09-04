module Marketplace
  class DeliveryPlace
    include Mongoid::Document

    field :state
    field :region
    field :region_okato
    field :address

    embedded_in :lot
  end
end