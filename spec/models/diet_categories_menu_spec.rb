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

require 'rails_helper'

RSpec.describe DietCategoriesMenu, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
