class User::SubscriptionsController < User::BaseController
  respond_to :js, only: :cancel

  def index
    @plan = current_user.plan
    @subscription = StripeSubscriptioner.new(current_user).retrieve
  end

  def cancel
    @canceler = SubscriptionCanceler.new(current_user, params[:body])
    if @canceler.run
      remove_referrer
      remove_candidate
      SubscriptionWorkerCanceller.call(user_id: current_user.id)
      @response_msg = response_msg("success", "Successfuly canceled subscription")
      respond_with(@response_msg)
    else
      remove_referrer
      remove_candidate
      SubscriptionWorkerCanceller.call(user_id: current_user.id)
      PlanCommenter.call(
        plan_id: current_user.plan_id, 
        comment_body: params[:body], 
        user_id: current_user.id
      )
      current_user.update_attributes(
        stripe_subscription_id: nil,
        plan_id: Plan.where(interval: [nil, ''], for_type: 'individual').take.id
      )
      @response_msg = response_msg("success", "Successfuly canceled subscription")
      respond_with(@response_msg)
    end
  end

  def choose_plans
    if current_user.subscribed?
      redirect_to user_subscriptions_path
    end
    @active_zip_code = current_user.active_address.zip_code
    @allowed_zip_codes = AllowedZipCode.pluck(:zip)
    @plans = Plan.subscriptions.sort
  end

  def subscribe
    subscribe_to_plan
    @subscription = StripeSubscriptioner.new(current_user)
    if @subscription.run
      redirect_to user_subscriptions_path, notice: "Subscription successful"
    else
      current_user.update_attributes(plan_id: nil)
      flash[:error] = @subscription.errors.full_messages.join(", ")
      redirect_back fallback_location: :back
    end
  end

  def create
    subscribe_to_plan
    @user = current_user
    @subscription = StripeSubscriptioner.new(@user)
    is_valid = validate_group_code
    if @subscription.run
      create_candidate if @user.plan.group? && is_valid
      create_referrer if @user.plan.group? && !is_valid
      redirect_to user_subscriptions_path, notice: "Subscription successful"
    else
      remove_plan
      flash[:error] = @subscription.errors.full_messages.join(", ")
      redirect_back fallback_location: :back
    end
  end

  private

  def remove_plan
    @user.update_attributes(plan_id: nil)
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
    @user.create_referrer!(group_code: code)
    flash[:notice] = "Your group code is #{code}"
  end

  def create_candidate
    @user.create_candidate!(referrer_id: @referrer.id)
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

  def subscribe_to_plan
    user = current_user
    user.update_attributes(plan_id: params[:id])
  end

  def response_msg(status, message)
    {
      status: status,
      message: message,
    }
  end
end
