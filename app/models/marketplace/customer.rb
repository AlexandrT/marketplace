module Marketplace
  class Customer
    include Mongoid::Document

    field :name
    field :bik
    field :ls_number
    field :rs_nimber
    field :real_address
    field :post_address

    embeds_one :contact
    embedded_in :lot
  end
end