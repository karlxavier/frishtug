# Subscription Canceler accepts a User Object and a feedback message
class SubscriptionCanceler
  include ActiveModel::Validations

  def initialize(user, feedback)
    @user = user
    @plan = @user.plan
    @feedback = feedback
  end

  def run
    @subscription = StripeSubscriptioner.new(user)
    if @subscription.cancel
      create_a_feedback
      unsubscribe_user
      true
    else
      errors.add(:base, @subscription.errors.full_messages.join(', '))
      false
    end
  end

  private

  attr_accessor :user, :feedback, :plan

  def create_a_feedback
    return nil if feedback.empty?
    PlanCommenter.call(
      plan_id: plan.id, 
      comment_body: feedback,
      user_id: user.id
    )
  end

  def unsubscribe_user
    user.update_attributes(
      stripe_subscription_id: nil,
      plan_id: Plan.where(interval: [nil, ''], for_type: 'individual').take.id
    )
  end
end
