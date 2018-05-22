class SerializableMenu < JSONAPI::Serializable::Resource
  include CloudinaryHelper
  type 'menus'
  attributes :name,
             :price,
             :notes,
             :description,
             :published_at,
             :published,
             :unit_size,
             :tax,
             :menu_category,
             :unit,
             :diet_categories,
             :asset

    meta do
      {
        add_ons: @object.add_ons.map do |a|
          {
            id: a.id,
            menu_id: a.menu_id,
            name: a.name,
            menu_category_id: a.menu_category_id,
            price: a.price
          }
        end
      }
    end
end