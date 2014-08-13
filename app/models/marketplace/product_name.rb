module Marketplace
  class ObjectInfo
    class ProductName
      include Mongoid::Document

      field :headers, type: Array
      field :rows, type: Array
      embedded_in :object_info
    end
  end
end