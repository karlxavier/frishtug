class User::ChangeSubscriptionsController < User::BaseController

  def index
    @plans = Plan.subscriptions.where.not(id: current_user.plan_id).sort
  end

  def create
    plan = Plan.find(params[:id])
    change_current_subscription
    current_user.update_attributes(plan_id: plan.id)
    create_join_group if plan.group?
    remove_from_group if plan.individual?
  rescue => e
    flash[:error] = e.message
    redirect_back fallback_location: :back
  end

  private

  def create_join_group
    is_valid = validate_group_code
    create_candidate if is_valid
    create_referrer unless is_valid
  end
  
  def remove_from_group
    remove_referrer
    remove_candidate
  end

  def change_current_subscription
    @subscription = Stripe::Subscription.retrieve(current_user.stripe_subscription_id)
    @subscription.cancel_at_period_end = false
    @subscription.items = [{
        id: @subscription.items.data[0].id,
        plan: plan.stripe_plan_id,
    }]
    @subscription.save
  end

  def remove_referrer
    if current_user.referrer?
      current_user.referrer.destroy
    end
  end

  def remove_candidate
    if current_user.candidate?
      current_user.candidate.destroy
    end
  end

  def create_referrer
    code = SecureRandom.urlsafe_base64(10)
    current_user.create_referrer!(group_code: code)
    flash[:notice] = "Your group code is #{code}"
  end

  def create_candidate
    current_user.create_candidate!(referrer_id: @referrer.id)
    flash[:notice] = "You successfully joined the group!"
  end

  def validate_group_code
    return false unless params[:group_code].present?
    @referrer = Referrer.find_by_group_code(params[:group_code])
    unless @referrer
      remove_plan
      flash[:error] = "Invalid group code!"
      redirect_back fallback_location: :back
    end
    true
  end

  def response_msg(status, message)
    {
      status: status,
      message: message
    }
  end
end
