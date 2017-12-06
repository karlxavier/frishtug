class User::PaymentInformationsController < User::BaseController
  def index
    @payment_informations = StripeCustomer.new(current_user)
  end

  def new; end

  def create
    @payment_method = PaymentMethodForm.new(
      type: params[:type],
      credit_card: credit_card_params,
      checking: checking_params,
      user: current_user
    )
    if @payment_method.save
      @msg = {
        status: 'success',
        message: 'Successfully created a new payment method'
      }
    else
      @msg = {
        status: 'error',
        message: @payment_method.errors.full_messages.join(', ')
      }
    end
    render json: @msg, status: :ok
  end

  def update
    @payment_method = PaymentMethodForm.new(
      type: params[:type],
      credit_card: credit_card_params,
      checking: checking_params,
      user: current_user
    )
    if @payment_method.update
      @msg = {
        status: 'success',
        message: 'Successfully updated payment method'
      }
    else
      @msg = {
        status: 'error',
        message: @payment_method.errors.full_messages.join(', ')
      }
    end
    render json: @msg, status: :ok
  end

  private

  def credit_card_params
    params.fetch(:credit_card, {}).permit(
      :number,
      :cvc,
      :month,
      :year,
      :token,
      :brand,
      :name,
      address_attributes: %i[
        id
        line1
        line2
        city
        state
        zip_code
      ]
    )
  end

  def checking_params
    params.fetch(:checking, {}).permit(
      :account_number,
      :routing_number,
      :bank_name,
      :token
    )
  end
end
