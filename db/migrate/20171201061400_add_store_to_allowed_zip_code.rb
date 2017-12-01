class AddStoreToAllowedZipCode < ActiveRecord::Migration[5.1]
  def change
    add_reference :allowed_zip_codes, :store, foreign_key: true
  end
end
