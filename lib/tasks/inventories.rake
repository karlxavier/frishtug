namespace :inventories do
  task remove_dupes: :environment do
    uniq_ids = Inventory.select('MIN(id) as id').group(:menu_id).collect(&:id)
    Inventory.where.not(id: uniq_ids).destroy_all
  end
end
