class AddChargeIdToLedgers < ActiveRecord::Migration[5.1]
  def change
    add_column :ledgers, :charge_id, :string
  end
end
