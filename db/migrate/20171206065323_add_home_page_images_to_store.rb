class AddHomePageImagesToStore < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :home_page_images, :string, array: true, default: []
  end
end
