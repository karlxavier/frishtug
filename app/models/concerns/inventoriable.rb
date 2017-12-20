module Inventoriable
  extend ActiveSupport::Concern

  included do
    after_create :create_inventory_entry
  end

  def create_inventory_entry
    create_inventory!(inventory_id: SecureRandom.urlsafe_base64(10))
  end
end
