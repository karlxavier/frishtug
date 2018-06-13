# == Schema Information
#
# Table name: diet_categories_menus
#
#  id               :bigint(8)        not null, primary key
#  diet_category_id :bigint(8)
#  menu_id          :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class DietCategoriesMenu < ApplicationRecord
end
