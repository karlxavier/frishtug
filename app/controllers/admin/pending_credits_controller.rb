class Admin::PendingCreditsController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @pending_credits = PendingCredit.all.order("#{sort_column} #{sort_direction}").page(page).per(20)
  end

  private

  def page
    params[:page]
  end

  def sort_column
    PendingCredit.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
