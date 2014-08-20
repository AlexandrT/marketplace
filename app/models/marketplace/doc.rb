module Marketplace
  class Doc
    include Mongoid::Document

    embeds_one :notice
    embeds_one :change_org
    embeds_one :receipt_result
    embeds_one :provider_cancel
    embeds_one :clarification_doc
    embeds_one :protocol
  end
end