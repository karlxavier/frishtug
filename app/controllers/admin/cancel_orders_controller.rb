class Admin::CancelOrdersController < Admin::BaseController
  def create
    CancelOrdersWorker.perform_async
    redirect_to admin_dashboard_index_path, notice: 'Processing cancellation of orders.'
  end
end