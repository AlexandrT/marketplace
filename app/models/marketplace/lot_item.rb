module Marketplace
  class LotItem
    include Mongoid::Document

    field :okdp
    field :okved
    field :measure
    field :count
    field :additional_info
    field :delivery_place

    embedded_in :lot
  end
end