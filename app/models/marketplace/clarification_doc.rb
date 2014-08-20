module Marketplace
  class Doc
    class ClarificationDoc
      include Mongoid::Document

      field :names, type: Array
      field :links, type: Array
      embedded_in :notice
    end
  end
end