class Admin::ScanovatorsController < Admin::BaseController
  before_action :set_date
  respond_to :js
  SKIPPABLE_DATES = BlackoutDate.pluck_dates.freeze

  def create
    if @date.saturday?
      @message = "Nothing to process for tomorrow saturday"
    elsif SKIPPABLE_DATES.include?(@date.strftime('%B %d'))
      @message = "Nothing to process for Blackout Date #{@date.strftime('%B %d')}"
    else
      ScanovatorOrdersWorker.perform_async(@date)
      @message = "Process queued for #{@date.to_date}"
    end
    respond_with(@message)
  end

  private

  def set_date
    @date = Date.parse(params[:date])
  end
end
