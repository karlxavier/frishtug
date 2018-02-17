class AddPartOfPlanToMenuCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :menu_categories, :part_of_plan, :boolean, default: true
    add_index :menu_categories, :part_of_plan
  end
end
