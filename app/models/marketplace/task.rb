module Marketplace
  class Task
    include Mongoid::Document

    field :start_date, type: DateTime
    field :end_date, type: DateTime
    field :result, type: Boolean
  end
end