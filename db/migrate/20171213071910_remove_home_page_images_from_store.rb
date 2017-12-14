class RemoveHomePageImagesFromStore < ActiveRecord::Migration[5.1]
  def change
    remove_column :stores, :home_page_images, :string
  end
end
