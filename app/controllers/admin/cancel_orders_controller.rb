class Admin::CancelOrdersController < Admin::BaseController
  SKIPPABLE_DATES = BlackoutDate.pluck_dates.freeze
  def create
    current_time = Time.current
    if current_time.saturday?
      redirect_to admin_dashboard_index_path, notice: 'Nothing to cancel for saturday'
    elsif SKIPPABLE_DATES.include?(current_time.strftime("%B %d"))
      redirect_to admin_dashboard_index_path, notice: 'Nothing to cancel for Blackout date'
    else
      CancelOrdersWorker.perform_async
      redirect_to admin_dashboard_index_path, notice: 'Processing cancellation of orders.'
    end
  end
end