module Marketplace
	class Event
		include Mongoid::Document

		field :date
		field :description
	end
end