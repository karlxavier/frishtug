# == Schema Information
#
# Table name: diet_categories_menus
#
#  id               :integer          not null, primary key
#  diet_category_id :integer
#  menu_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class DietCategoriesMenu < ApplicationRecord
end
