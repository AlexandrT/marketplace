module Marketplace
  class Company
    include Mongoid::Document

    field :spz_code
    field :status
    field :date
    field :role
    field :full_name
    field :short_name
    field :inn
    field :kpp
    field :date_nalog
    field :org_type
    field :org_level
    field :okopf
    field :okogu
    field :okpo
    field :okved
    field :ogrn
    field :address
    field :okato
    field :authorized_org
    field :timezone

    embeds_one :budget
    embeds_one :parent_org
    embeds_one :ppo
    embeds_one :contact_org
  end
end