class AddMenuIdToAddOns < ActiveRecord::Migration[5.1]
  def change
    add_reference :add_ons, :menu, foreign_key: true
  end
end
