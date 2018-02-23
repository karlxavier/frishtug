class Admin::InventoryController < Admin::BaseController
  before_action :set_date_range

  def index
    @inventory_transactions = InventoryTransaction.between_transaction_date?(@date_range)
    respond_to do |format|
      format.html
      format.csv {
        send_data @inventory_transactions.to_csv,
          filename: "Inventory Report For #{@date.strftime('%D')}.csv"
      }
    end
  end

  private

  def set_date_range
    @date = Time.current
    @date_range = set_range
  end

  def set_range
    if params[:weekly]
      DateRange.new(@date.beginning_of_week, @date.end_of_week)
    elsif params[:monthly]
      DateRange.new(@date.beginning_of_month, @date.end_of_month)
    elsif params[:start_date] && params[:end_date]
      start_date = Time.zone.parse(params[:start_date])
      end_date = Time.zone.parse(params[:end_date])
      DateRange.new(start_date.beginning_of_day, end_date.end_of_day)
    else
      DateRange.new(@date.beginning_of_day, @date.end_of_day)
    end
  end
end
