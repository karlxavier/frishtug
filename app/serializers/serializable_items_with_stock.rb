class SerializableItemsWithStock < JSONAPI::Serializable::Resource
  type 'items_with_stocks'
  attributes :menu_id, :name, :price, :unit, :asset, :menu_category
end