module Marketplace
  class Contact
    include Mongoid::Document

    field :person
    field :phone
    field :email
    field :fax

    embedded_in :auth_organization
    embedded_in :customer
  end
end