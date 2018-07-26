class StripeCharger
  include ActiveModel::Validations

  def initialize(user, amount, order = nil)
    @user = user
    @amount = amount
    @order = order
  end

  def run
    create_a_customer unless @user.stripe_customer_id.present?
    response = Stripe::Charge.create(
      amount: amount_to_cents,
      currency: 'usd',
      customer: @user.stripe_customer_id,
      description: "Single Order Charge for #{@user.full_name} <#{@user.email}>"
    )
    { success: true, response: response }
  rescue => e
    errors.add(:base, e.message)
    { success: false, response: nil }
  end

  def charge_excess!
    return false if amount <= 0
    Stripe::Charge.create(
      amount: to_cents(amount),
      currency: 'usd',
      customer: @user.stripe_customer_id,
      description: charge_description("Additional")
    )
    true
  rescue => e
    errors.add(:base, e.message)
    create_user_notification(e, "additional_charge")
    false
  end

  def charge_tax!
    response = Stripe::Charge.create(
      amount: to_cents(amount),
      currency: 'usd',
      customer: @user.stripe_customer_id,
      description: charge_description("Tax")
    )
    response
  rescue => e
    errors.add(:base, e.message)
    create_user_notification(e, "tax_charge")
    false
  end

  def charge_shipping
    response = Stripe::Charge.create(
      amount: to_cents(amount),
      currency: 'usd',
      customer: @user.stripe_customer_id,
      description: charge_description("Shipping")
    )
    response
  rescue => e
    errors.add(:base, e.message)
    create_user_notification(e, "shipping_charge")
    false
  end

  private

  attr_accessor :amount, :user, :order

  def create_user_notification(e, type)
    body = e.json_body
    error = body[:error]
    user_notification = user.user_notifications.where(uniq_id: uniq_id(type)).first_or_create

    user_notification.update_attributes(
      title: error[:type].humanize,
      body: "#{e.message}. System will attempt to charge after an hour. Please update your payment information.",
      timeout: 5,
    )
    ChargeWorker.perform_async(user.id, order&.id, amount, type)
  end

  def uniq_id(type)
    [user.id, type, amount].join('_')
  end

  def charge_description(type)
    if order.present?
      "#{type} charge for order # #{order.id} placed on #{order.placed_on.strftime('%B %d, %Y')}"
    else
      "#{type} charge on #{Time.current.strftime('%B %d, %Y @ %I:%M %P')}"
    end
  end

  def to_cents(amount)
    (amount.to_d * 100).to_i
  end

  def amount_to_cents
    (amount.to_r * 100).to_i
  end

  def create_a_customer
     customer = StripeCustomer.new(user)
     unless customer.create
      errors.add(:base, customer.errors.full_messages.join(', '))
     end
  end
end
