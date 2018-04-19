class CreateSuggestionComplaints < ActiveRecord::Migration[5.1]
  def change
    create_table :suggestion_complaints do |t|
      t.integer :type
      t.string :email
      t.string :message

      t.timestamps
    end
  end
end
