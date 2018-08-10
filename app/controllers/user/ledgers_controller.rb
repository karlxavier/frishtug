class User::LedgersController < User::BaseController
  before_action :set_unpaid_bills, :subscribed_or_party_meeting_plan?

  def index
    @ledgers = @unpaid_bills.unpaid.page(page).per(10)
    @total = @unpaid_bills.total
  end

  def pay
    charge = Stripe::Charge.create(
      amount: amount_to_cents,
      currency: "usd",
      customer: current_user.stripe_customer_id,
      description: "Payment for bills",
    )
    @unpaid_bills.find_each { |b| b.update_attributes(status: :paid, charge_id: charge.id) }
    redirect_back fallback_location: :back, notice: "Payment successful"
  rescue => e
    flash[:error] = e.message
    @unpaid_bills.update_all(status: :payment_failed)
    redirect_back fallback_location: :back
  end

  private

  def page
    params[:page]
  end

  def set_unpaid_bills
    @unpaid_bills = current_user.ledgers.unpaid
  end

  def amount_to_cents
    (@unpaid_bills.total * 100).to_i
  end

  def orders_placed
    order_ids = @unpaid_bills.pluck(:order_id)
  end

  def subscribed_or_party_meeting_plan?
    unless current_user.subscribed? || current_user.plan.party_meeting?
      flash[:error] = "You are not subscribe to any plan"
      redirect_back fallback_location: user_dashboard_index_path
    end
  end
end
