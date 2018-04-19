class Api::V1::Users::PaymentInformationController < Api::V1::Users::BaseController
  before_action :set_payment_info_form, only: %i[create update]
  def index
    @customer ||= StripeCustomer.new(current_user)
    render json: { status: 'success', data: @customer.sources }, status: :ok
  end

  def show
    @customer ||=  Stripe::Customer.retrieve(current_user.stripe_customer_id)
    @source = @customer.sources.retrieve(params[:id])
    render json: { status: 'success', data: @source }, status: :ok
  end

  def create
    if @payment_method.save
      render json: {
        status: 'success',
        message: 'Successfully created a new payment method'
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: @payment_method.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  def update
    if @payment_method.update
      render json: {
        status: 'success',
        message: 'Successfully updated payment method'
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: @payment_method.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  private

  def set_payment_info_form
    @payment_method = PaymentMethodForm.new(
      type: params[:type],
      credit_card: credit_card_params,
      checking: checking_params,
      user: current_user
    )
    end

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