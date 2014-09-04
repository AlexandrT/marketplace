module Marketplace
  class Contact
    include Mongoid::Document

    field :first_name
    field :middle_name
    field :last_name
    field :phone
    field :email
    field :fax

    embedded_in :order
  end
end