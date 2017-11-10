class AddStatusToAddress < ActiveRecord::Migration[5.1]
  def change
    add_column :addresses, :status, :integer
  end
end
