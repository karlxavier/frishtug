class AddAssetToMenu < ActiveRecord::Migration[5.1]
  def change
    add_reference :menus, :asset, foreign_key: true
  end
end
