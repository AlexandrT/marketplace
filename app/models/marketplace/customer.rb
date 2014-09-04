module Marketplace
  class Customer
    include Mongoid::Document

    field :full_name
    field :short_name
    field :inn
    field :kpp
    field :ogrn
    field :address
    field :post_address
    field :phone
    field :fax
    field :email
    field :okato
  end
end