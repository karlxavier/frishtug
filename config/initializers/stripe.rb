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
      next unless user
      user.stripe_subscription_id = subscription.id
      user.save
    end

    if event.type == 'invoice.upcoming'
      invoice = event.data.object
      user = User.find_by_stripe_customer_id(invoice.customer)
      next unless user
      user.user_notifications.create!({
        title: 'Subscription Notice!',
        body: 'This is a notice to remind you that your subscription is scheduled for automatic charge.',
        timeout: 5
      })
    end

    if event.type == 'customer.subscription.created'
      subscription = event.data.object
      user = User.find_by_stripe_customer_id(subscription.customer)
      next unless user
      next if user.stripe_subscription_id == subscription.id
      user.stripe_subscription_id = subscription.id
      user.save
      OrderCopierWorker.perform_at(1.hour.from_now, user.id)
    end

    if event.type == 'customer.subscription.deleted'
      subscription = event.data.object
      user = User.find_by_stripe_customer_id(subscription.customer)
      next unless user
      next if user.stripe_subscription_id == subscription.id
      user.stripe_subscription_id = nil
      user.save
    end
  end
end