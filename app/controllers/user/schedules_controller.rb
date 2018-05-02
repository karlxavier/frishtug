class User::SchedulesController < User::BaseController
  before_action :user_has_schedule!

  def index
    @schedule = current_user.schedule
  end

  def create
    @schedule = current_user.schedule
    @schedule = current_user.create_schedule(option: nil) unless current_user.schedule.present?
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
    unless current_user.subscribed?
      flash[:error] = "You are not subscribe to any plan"
      redirect_back fallback_location: user_dashboard_index_path
    end
  end
end