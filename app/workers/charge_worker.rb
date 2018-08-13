class ChargeWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform(user_id, order_id, amount, type)
    @user = User.find_by_id(user_id)
    return unless @user
    @amount = amount
    @type = type
    return unless @user.present?
    return unless @amount.present?
    return unless @type.present?
    @order = order_id.present? ? Order.find(order_id) : nil
    response = Stripe::Charge.create(
      amount: amount_in_cents,
      currency: "usd",
      customer: @user.stripe_customer_id,
      description: charge_description,
    )
    delete_user_notification if response.id.present?
  end

  private

  def delete_user_notification
    notification = UserNotification.find_by_uniq_id(uniq_id)
    return unless notification.present?
    notification.destroy
  end

  def uniq_id
    [@user.id, @type, @amount].join("_")
  end

  def amount_in_cents
    (@amount.to_d * 100).to_i
  end

  def charge_description
    if @order.present?
      "#{@type} charge for order # #{@order.id} placed on #{@order.placed_on.strftime("%B %d, %Y")}"
    else
      "#{@type} charge on #{Time.current.strftime("%B %d, %Y @ %I:%M %P")}"
    end
  end
end
