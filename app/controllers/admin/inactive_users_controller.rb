class Admin::InactiveUsersController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @inactive_users = InactiveUser.all.order("#{sort_column} #{sort_direction}").page(page).per(20)
  end

  private

  def page
    params[:page]
  end

  def sort_column
    InactiveUser.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
