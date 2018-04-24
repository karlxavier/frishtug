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

    if event.type == 'customer.subscription.created'
      subscription = event.data.object
      subscription_start = Time.zone.at(subscription.current_period_start)
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

    if event.type == 'customer.subscription.updated'
      subscription = event.data.object
      subscription_start = Time.zone.at(subscription.current_period_start)
      subscription_end = Time.zone.at(subscription.current_period_end)
      user = User.find_by_stripe_customer_id(subscription.customer)
      if user && user.subscribe_at != subscription_start
        user.update_attributes(
          stripe_subscription_id: subscription.id,
          subscribe_at: subscription_start,
          subscription_expires_at: subscription_end
        )
        OrderCopierWorker.perform_at(1.hour.from_now, user.id)
      end
    end

    if event.type == 'customer.subscription.deleted'
      subscription = event.data.object
      user = User.find_by_stripe_customer_id(subscription.customer)
      if user
        user.stripe_subscription_id = nil
        user.plan_id = nil
        user.save
      end
    end
  end
end