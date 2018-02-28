class CreateBlackoutDates < ActiveRecord::Migration[5.1]
  def change
    create_table :blackout_dates do |t|
      t.string :month
      t.integer :day
      t.string :description

      t.timestamps
    end
  end
end
