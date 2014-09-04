module Marketplace
  class Organization
    include Mongoid::Document

    field :name
    field :bik
    field :ls_number
    field :rs_nimber
    field :real_address
    field :post_address

    embedded_in :order
  end
end