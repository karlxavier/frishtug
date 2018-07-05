namespace :fix_users_plan do
  desc "Renewal for subscribe users"
  task run: :environment do
    subscribed_users =
      User.where.not(subscribe_at: nil)

    subscribed_users.find_each do |user|
      plan_id = user.plan_id

      subscription =
        Stripe::Subscription.retrieve(user.stripe_subscription_id)

      plan = Plan.find_by_stripe_plan_id(subscription.plan.id)
      user.update_attributes(plan_id: plan.id)
    end
  end
end
