module Marketplace
  class DeliveryPlace
    include Mongoid::Document

    field :address

    embedded_in :lot
  end
end