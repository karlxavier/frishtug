class AddShippingNoteToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :shipping_note, :string
  end
end
