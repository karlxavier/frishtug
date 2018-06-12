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
    @start_date = @date_range.start_date
    @end_date = @date_range.end_date
  end

  def set_range
    if params[:weekly]
      DateRange.new(@date.beginning_of_week, @date.end_of_week)
    elsif params[:monthly]
      DateRange.new(@date.beginning_of_month, @date.end_of_month)
    elsif start_date || end_date
      DateRange.new(parse_date(start_date).beginning_of_day, parse_date(end_date).end_of_day)
    else
      DateRange.new(@date.beginning_of_day, @date.end_of_day)
    end
  end

  def start_date
    params[:start_date]
  end

  def end_date
    params[:end_date] != 'undefined' ? params[:end_date] : start_date
  end

  def parse_date(date)
    Time.zone.parse(date)
  end
end
