class AddFileNameToAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :file_name, :string
    add_index :assets, :file_name
  end
end
