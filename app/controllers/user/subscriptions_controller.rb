class User::SubscriptionsController < User::BaseController
  respond_to :js, only: :cancel

  def index
    @plan = current_user.plan
    @subscription = StripeSubscriptioner.new(current_user).retrieve
  end

  def cancel
    @canceler = SubscriptionCanceler.new(current_user, params[:body])
    # if @canceler.run
    if @canceler.run
      @response_msg = response_msg('success', 'Successfuly canceled subscription')
      respond_with(@response_msg)
    else
      @response_msg = response_msg('error', @canceler.errors.full_messages.join(', '))
      respond_with(@response_msg)
    end
  end

  private

    def response_msg(status, message)
      {
        status: status,
        message: message
      }
    end
end
