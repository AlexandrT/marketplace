module Marketplace
  class Order
    include Mongoid::Document

    field :remote_id
    field :type
    field :name

    embeds_one :auth_organization
    embeds_many :customers
    embeds_many :lots
  end
end