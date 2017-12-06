module Inventoriable
  extend ActiveSupport::Concern

  included do
    before_create :create_inventory
  end

  private

  def create_inventory
    self.create_inventory!(inventory_id: SecureRandom.urlsafe_base64(10))
  end
end