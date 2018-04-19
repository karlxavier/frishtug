class Api::V1::Users::SchedulesController < Api::V1::Users::BaseController
  def index
    @schedule = current_user.schedule
    if @schedule
      render json: {
        status: 'success',
        data: @schedule
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'User has no schedule'
      }, status: :not_found
    end
  end

  def create
    @schedule = current_user.schedule
    if @schedule.update_attributes(option: option)
      flash[:success] = "Schedule successfully changed to #{option.humanize}"
    else
      flash[:error] = "Error: #{ @schedule.errors.full_messages.join(', ') }"
    end
    redirect_back fallback_location: user_dashboard_index_path
  end

  private

  def option
    params[:option]
  end

  def user_has_schedule!
    unless current_user.schedule.present? && current_user.subscribed?
      redirect_back fallback_location: user_dashboard_index_path
    end
  end
end