class Api::V1::Users::SubscriptionsController < Api::V1::Users::BaseController
  def index
    @subscription = StripeSubscriptioner.new(current_user).retrieve
    render json: { status: 'success', data: @subscription }, status: :ok
  end

  def cancel
    @canceler = SubscriptionCanceler.new(current_user, params[:suggestions])
    if @canceler.run
      render json: {
        status: 'success',
        message: 'Successfuly canceled subscription'
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: @canceler.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  def subscribe
    subscribe_to_plan
    @subscription = StripeSubscriptioner.new(current_user)
    if @subscription.run
      render json: {
        status: 'success',
        message: 'Subscription successful'
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: @subscription.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
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
end