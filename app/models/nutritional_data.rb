class NutritionalData < ApplicationRecord
  belongs_to :menu

  scope :nutri_data, -> (menu_id) { select('nutritional_data.id', 'menus.name AS menu_name', 'nutritional_data.data', 'nutritional_data.menu_id').where(menu_id: menu_id).joins(:menu) }
end
