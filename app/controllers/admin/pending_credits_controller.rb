class Admin::PendingCreditsController < Admin::BaseController
  def index
    @pending_credits = PendingCredit.all.page(page).per(20)
  end

  private

  def page
    params[:page]
  end
end