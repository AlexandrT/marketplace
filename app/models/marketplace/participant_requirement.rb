module Marketplace
  class OrderInfo
    class ParticipantRequirement
      include Mongoid::Document

      field :privelege
      field :requirement
      field :restriction
      field :additional_info
      embedded_in :order_info
    end
  end
end