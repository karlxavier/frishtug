Rails.configuration.stripe = {
  publishable_key: ENV["STRIPE_PUBLISHABLE_KEY"],
  secret_key: ENV["STRIPE_SECRET_KEY"]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
STRIPE_PUBLIC_KEY = Rails.configuration.stripe[:publishable_key]
StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET']

StripeEvent.configure do |events|
  events.all do |event|
    if event.type == 'customer.subscription.updated'
      subscription = event.data.object
      user = User.find_by_stripe_customer_id(subscription.customer)
      if user
        user.stripe_subscription_id = subscription.id
        user.save
      end
    end

    if event.type == 'invoice.payment_failed'
      invoice_data = event.data.object
      user = User.find_by_stripe_customer_id(invoice_data.customer)
      if user
        if invoice_data.next_payment_attempt.nil?
          user.orders.where(status: [:processing, :awaiting_shipment]).each do |order|
            order.payment_failed!
          end
        else
          user.user_notifications.create!({
            title: 'Payment Failed',
            body: "Next payment attempt will be #{Time.zone.at(invoice_data.next_payment_attempt).to_date}. Please update your payment info.",
            timeout: 5
          })
          user.orders.where(status: [:processing, :awaiting_shipment]).update_all(status: :pending_payment)
        end
      end
    end

    if event.type == 'customer.subscription.created'
      subscription = event.data.object
      subscription_start = Time.zone.at(subscription.billing_cycle_anchor)
      subscription_end = Time.zone.at(subscription.current_period_end)
      user = User.find_by_stripe_customer_id(subscription.customer)
      if user
        user.update_attributes(
          stripe_subscription_id: subscription.id,
          subscribe_at: subscription_start,
          subscription_expires_at: subscription_end
        )
      end
    end
  end
end