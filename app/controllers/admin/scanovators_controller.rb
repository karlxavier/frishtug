class Admin::ScanovatorsController < Admin::BaseController
  respond_to :js
  def create
    ScanovatorOrdersWorker.perform_async(params[:date])
    @message = "Process queued"
    respond_with(@message)
  end
end
