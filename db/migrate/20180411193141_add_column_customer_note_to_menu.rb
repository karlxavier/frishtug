class AddColumnCustomerNoteToMenu < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :notes, :string
  end
end
