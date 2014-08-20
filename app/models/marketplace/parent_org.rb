module Marketplace
  class Company
    class ParentOrg
      include Mongoid::Document

      field :spz_code
      field :name

      embedded_in :company
    end
  end
end