class Admin::InventoryController < Admin::BaseController
  before_action :set_date_range
  def index
    @inventory_transactions = InventoryTransaction.between_transaction_date?(@date_range)
  end

  private

  def set_date_range
    @date = Time.current
    @date_range = DateRange.new(@date.beginning_of_day, @date.end_of_day)
  end
end
