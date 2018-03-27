class Admin::ClientsController < Admin::BaseController
  before_action :set_user, only: :show
  def index
    @search_url = admin_clients_path
    @search_placeholder = "Last name or First name"
    @users = User.search(search_term).page(page).per(20)
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
end
