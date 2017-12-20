class InventoryQtyWorker
  include Sidekiq::Worker

  def perform(menu_ids, quantities)
    index = 0
    Inventory.transaction do
      while index < menu_ids.size
        inventory = Inventory.find_or_create_by!(menu_id: menu_ids[index])
        inventory.update_attributes!(quantity: quantities[index])
        if inventory.inventory_id.nil?
          inventory.update_attributes!(inventory_id: SecureRandom.urlsafe_base64(10))
        end
        index += 1
      end
    end
  end
end
