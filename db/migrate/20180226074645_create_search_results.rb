class CreateSearchResults < ActiveRecord::Migration[5.1]
  def change
    create_view :search_results
  end
end
