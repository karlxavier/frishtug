class Admin::ClientsController < Admin::BaseController
  before_action :set_user, only: :show
  helper_method :sort_column, :sort_direction

  def index
    @search_url = admin_clients_path
    @search_placeholder = "Last name or First name"
    @users = User.search(search_term).order("#{sort_column} #{sort_direction}").page(page).per(20)
  end

  def show
    @hide_search_form = true
    @user_orders = @user.orders
  end

  private

  def search_term
    params[:search_term]
  end

  def page
    params[:page]
  end

  def set_user
    @user = User.find(params[:id])
  end

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
