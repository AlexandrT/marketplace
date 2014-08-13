module Marketplace
  class OrderInfo
    include Mongoid::Document

    field :original_id
    embeds_one :common_info
    embeds_one :contact_info
    embeds_one :proc_info
    embeds_one :max_cost
    embeds_one :object_info
    embeds_one :participant_requirement
    embeds_one :customer_requirement
  end
end