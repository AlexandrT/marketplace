module Marketplace
  class AuthOrganization
    include Mongoid::Document

    field :full_name
    field :short_name
    field :inn
    field :kpp
    field :ogrn
    field :address
    field :post_address
    field :okato

    embeds_one :contact
    embedded_in :order
  end
end