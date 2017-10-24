class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.integer :option
      t.datetime :start_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
