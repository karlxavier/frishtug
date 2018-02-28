class Admin::InactiveUsersController < Admin::BaseController
  def index
    @inactive_users = InactiveUser.all.page(page).per(10)
  end

  private

  def page
    params[:page]
  end
end
