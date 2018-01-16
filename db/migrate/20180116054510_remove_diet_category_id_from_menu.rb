class RemoveDietCategoryIdFromMenu < ActiveRecord::Migration[5.1]
  def change
    remove_reference :menus, :diet_category, foreign_key: true
  end
end
