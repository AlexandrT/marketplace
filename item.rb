class Item

end

class DbItem 
	include Mongoid::Document

	field :original_id
	field :contacts, type: Hash, default: ->(){Hash.new}
	field :documents, type: Array, default: ->(){[]}

	embeds_many :documnets, class_name: "DbItem::Documnet"
end

class DbItem::Documnet 
	field :title
	field :number
	embedded_in :item
end