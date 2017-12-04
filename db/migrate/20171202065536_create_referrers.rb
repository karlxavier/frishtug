class CreateReferrers < ActiveRecord::Migration[5.1]
  def change
    create_table :referrers do |t|
      t.references :user, foreign_key: true
      t.string :group_code

      t.timestamps
    end
  end
end
