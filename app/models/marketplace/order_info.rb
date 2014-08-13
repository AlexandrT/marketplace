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

class CommonInfo
  include Mongoid::Document

  field :type
  field :platform_name
  field :platform_address
  field :customer_name
  field :step
  field :relation_with_plan
  embedded_in :order_info
end
