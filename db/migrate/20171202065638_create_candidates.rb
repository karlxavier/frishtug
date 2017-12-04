class CreateCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :candidates do |t|
      t.references :user, foreign_key: true
      t.references :referrer, foreign_key: true

      t.timestamps
    end
  end
end
