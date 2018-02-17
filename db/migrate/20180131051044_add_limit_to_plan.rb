class AddLimitToPlan < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :limit, :decimal, precision: 8, scale: 2
  end
end
