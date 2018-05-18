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

    if event.type == 'invoice.upcoming'
      invoice = event.data.object
      user = User.find_by_stripe_customer_id(invoice.customer)
      if user
        user.user_notifications.create!({
          title: 'Subscription Notice!',
          body: 'This is a notice to remind you that your subscription is scheduled for automatic charge.',
          timeout: 5
        })
      end
    end

    if event.type == 'invoice.created'
      invoice_data = event.data.object
      user = User.find_by_stripe_customer_id(invoice_data.customer)
      if user
        invoice = Stripe::Invoice.retrieve(invoice_data.id)
        invoice.pay
      end
    end

    if event.type == 'invoice.payment_succeeded'
      invoice_data = event.data.object
      user = User.find_by_stripe_customer_id(invoice_data.customer)
      data = invoice_data.lines.data[0]
      if user && data.type == 'subscription'
        subscription_start = Time.zone.at(data.period.start)
        subscription_end = Time.zone.at(data.period.end)
        if user.subscribe_at != subscription_start
          user.update_attributes(
            stripe_subscription_id: subscription.id,
            subscribe_at: subscription_start,
            subscription_expires_at: subscription_end
          )
          OrderCopierWorker.perform_at(1.hour.from_now, user.id)
        else
          user.orders.where.not(status: [:fresh, :fulfilled, :completed, :failed]).update_all(status: :processing)
        end
      end
    end

    if event.type == 'invoice.payment_failed'
      invoice_data = event.data.object
      user = User.find_by_stripe_customer_id(invoice_data.customer)
      if user
        return if invoice_data.next_payment_attempt.nil?
        user.user_notifications.create!({
          title: 'Payment Failed',
          body: "Next payment attempt will be #{Time.zone.at(invoice_data.next_payment_attempt).to_date}. Please update your payment info.",
          timeout: 5
        })
        user.orders.processing.update_all(status: :pending_payment)
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

    if event.type == 'customer.subscription.deleted'
      subscription = event.data.object
      user = User.find_by_stripe_customer_id(subscription.customer)
      if user
        user.update_attributes(
          stripe_subscription_id: nil,
          subscribe_at: nil,
          subscription_expires_at: nil,
          plan_id: nil
        )
      end
    end
  end
end