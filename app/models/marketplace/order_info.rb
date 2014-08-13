class OrderInfo
  include Mongoid::Document

  field :original_id
  field :common_info, type: Hash, default ->(){Hash.new}
  field :contact_info, type: Hash, default ->(){Hasn.new}
  field :proc_info, type: Hash, default ->(){Hash.new}
  field :max_cost, type: Hash, default ->(){Hash.new}
  field :object_info, type: Hash, default ->(){Hash.new}
  field :participant_requirements, type: Hash, default ->(){Hash.new}
  field :customer_requirements, type: Hash, default ->(){Hash.new}
end
