module Marketplace
  class OrderInfo
    class ContactInfo
      include Mongoid::Document

      field :organization
      field :post_address
      field :ur_address
      field :person
      field :email
      field :phone
      field :fax
      field :additional_info
      embedded_in :order_info
    end
  end
end