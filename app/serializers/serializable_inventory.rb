class SerializableInventory < JSONAPI::Serializable::Resource
  type 'inventories'
  attributes :id, :menu_id, :quantity
end