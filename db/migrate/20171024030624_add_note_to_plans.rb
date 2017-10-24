class AddNoteToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :note, :text
  end
end
