class User::LedgersController < User::BaseController
  before_action :set_unpaid_bills, :user_must_be_subscribed!
  def index
    @ledgers = @unpaid_bills.unpaid.page(page).per(10)
    @total = @unpaid_bills.total
  end

  def pay
    Stripe::Charge.create(
      amount: amount_to_cents,
      currency: 'usd',
      customer: current_user.stripe_customer_id,
      description: "Payment for bills"
    )
    @unpaid_bills.update_all(status: :paid)
    create_bill_history
    redirect_back fallback_location: :back, notice: 'Payment successful'
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

  def create_bill_history
    type = { "TaxLedger" => "tax", "ExcessLedger" => "excess"}
    @unpaid_bills.each do |bill|
      RecordPayments.call(bill.order, bill.amount, type[bill.type])
    end
  end

  def user_must_be_subscribed!
    unless current_user.subscribed?
      flash[:error] = "You are not subscribe to any plan"
      redirect_back fallback_location: user_dashboard_index_path
    end
  end
end