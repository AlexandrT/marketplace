module Marketplace
  class Company
    class Ppo
      include Mongoid::Document

      field :code_oktmo
      field :name

      embedded_in :company
    end
  end
end