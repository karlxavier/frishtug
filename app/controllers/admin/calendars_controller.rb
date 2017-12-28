class Admin::CalendarsController < Admin::BaseController
  respond_to :js

  def index
    @date = Date.parse(params[:selected_date])
    @calendar_date = Date.parse(params[:calendar_date])
  end
end
