class CreateAllowedZipCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :allowed_zip_codes do |t|
      t.string :zip

      t.timestamps
    end
    add_index :allowed_zip_codes, :zip
  end
end
