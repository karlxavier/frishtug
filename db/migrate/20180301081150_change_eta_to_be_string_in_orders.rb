class ChangeEtaToBeStringInOrders < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :eta, :string
  end
end
