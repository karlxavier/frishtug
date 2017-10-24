class AddLocationAtToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :location_at, :integer
  end
end
