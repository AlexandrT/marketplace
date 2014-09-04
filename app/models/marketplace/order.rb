module Marketplace
  class Order
    include Mongoid::Document

    field :remote_id
    field :type
    field :name
    field :currency

    embeds_many :contacts
    embeds_many :organizations
    embeds_many :lots
  end
end