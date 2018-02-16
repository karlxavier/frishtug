class BillHistoryService
  def initialize(user)
    @user = user
  end

  def run
    get_bill_histories
  end

  private

  attr_accessor :user

  def customer_id
    user.stripe_customer_id
  end

  def get_bill_histories
    Stripe::Charge.list(customer: customer_id, limit: 100)
  end
end