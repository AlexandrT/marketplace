module Marketplace
  class Company
    class Budget
      include Mongoid::Document

      field :code_budget
      field :name_budget

      embedded_in :company
    end
  end
end