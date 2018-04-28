class Admin::ScanovatorsController < Admin::BaseController
  before_action :set_date
  respond_to :js
  def create
    if @date.saturday?
      @message = "Nothing to process for tomorrow saturday"
    else
      ScanovatorOrdersWorker.perform_async(@date)
      @message = "Process queued for #{@date.to_date}"
    end
    respond_with(@message)
  end

  private

  def set_date
    @date = Date.parse(params[:date])
    @date += 1.day
  end
end
