class AddDescriptionToMenu < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :description, :text
  end
end
