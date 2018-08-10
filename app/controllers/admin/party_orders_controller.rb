class Admin::PartyOrdersController < Admin::BaseController
  def index
    @party_orders = Order.joins(:user).where(status: %i[processing pending_payment]).merge(users_in_party_meeting_plan).order(created_at: :desc).page(params[:page]).per(20)
  end

  private

  def users_in_party_meeting_plan
    User.joins(:plan).merge(Plan.where(for_type: "party_meeting"))
  end
end
