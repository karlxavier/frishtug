class RemoveImageFromMenu < ActiveRecord::Migration[5.1]
  def change
    remove_column :menus, :image, :string
  end
end
