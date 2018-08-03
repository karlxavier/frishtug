class AddChargeIdToBillHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :bill_histories, :charge_id, :string
  end
end
