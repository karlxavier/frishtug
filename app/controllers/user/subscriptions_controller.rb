class User::SubscriptionsController < User::BaseController
  respond_to :js, only: :cancel

  def index
    @plan = current_user.plan
    @subscription = StripeSubscriptioner.new(current_user).retrieve
  end

  def cancel
    @canceler = SubscriptionCanceler.new(current_user, params[:body])
    if @canceler.run
      @response_msg = response_msg('success', 'Successfuly canceled subscription')
      respond_with(@response_msg)
    else
      @response_msg = response_msg('error', @canceler.errors.full_messages.join(', '))
      respond_with(@response_msg)
    end
  end

  def choose_plans
    @plans = Plan.subscriptions.sort
  end

  def subscribe
    subscribe_to_plan
    @subscription = StripeSubscriptioner.new(current_user)
    if @subscription.run
      redirect_to user_subscriptions_path, notice: 'Subscription successful'
    else
      flash[:error] = @subscription.errors.full_messages.join(', ')
      redirect_back fallback_location: :back
    end
  end

  private

  def subscribe_to_plan
    user = current_user
    user.update_attributes(plan_id: params[:id])
    create_referrer(user) if user.plan.for_type == 'group'
  end

  def create_referrer(user)
    user.create_referrer!(group_code: SecureRandom.urlsafe_base64(10))
  end

  def response_msg(status, message)
    {
      status: status,
      message: message
    }
  end
end
