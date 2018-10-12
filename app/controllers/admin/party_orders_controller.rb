class Admin::PartyOrdersController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @party_orders = Order.joins(:user).where(status: %i[processing pending_payment awaiting_shipment]).merge(users_in_party_meeting_plan).order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
  end

  private

  def users_in_party_meeting_plan
    User.joins(:plan).merge(Plan.where(for_type: "party_meeting"))
  end

  def sort_column
    Order.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
