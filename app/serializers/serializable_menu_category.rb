class SerializableMenuCategory < JSONAPI::Serializable::Resource
  type 'menu_categories'
  attributes :name, :part_of_plan, :display_order
end