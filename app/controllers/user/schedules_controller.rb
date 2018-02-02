class User::SchedulesController < User::BaseController
  before_action :user_has_schedule!

  def index
    @schedule = current_user.schedule
  end

  def create
    if current_user.schedule.update_attributes(option: option)
      flash[:success] = "Schedule successfully changed to #{option.humanize}"
      redirect_back fallback_location: :back
    end
  end

  private

  def option
    params[:option]
  end

  def user_has_schedule!
    unless current_user.schedule.present?
      redirect_back fallback_location: :back
    end
  end
end