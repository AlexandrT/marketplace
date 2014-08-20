module Marketplace
  class Company
    class ContactOrg
      include Mongoid::Document

      field :phone
      field :fax
      field :post_address
      field :email
      field :site
      field :person
      field :additional_info

      embedded_in :company
    end
  end
end