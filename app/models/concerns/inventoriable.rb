module Inventoriable
  extend ActiveSupport::Concern

  included do
    after_create :create_inventory_entry
  end

  def create_inventory_entry
    Inventory.where(menu_id: self[:id])
      .first_or_create!(inventory_id: SecureRandom.urlsafe_base64(10), menu_id: self[:id])
  end
end
