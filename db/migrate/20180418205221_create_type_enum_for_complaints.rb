class CreateTypeEnumForComplaints < ActiveRecord::Migration[5.1]
  def change
  	ActiveRecord::Base.connection.execute <<~SQL
      CREATE TYPE type AS ENUM ('suggestion', 'complaint');
    SQL

    remove_column :suggestion_complaints, :type
    add_column :suggestion_complaints, :type, :integer, default: 1, index: true
  end
end
