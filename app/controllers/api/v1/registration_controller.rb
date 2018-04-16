class Api::V1::RegistrationController < Api::V1::BaseController
  def create
    @registration = RegistrationForm.new(registration_params)
    if @registration.save
      command = AuthenticateUser.call(
        registration_params[:email], registration_params[:password])
      render json: {
        status: 'success',
        auth_token: command.result
      }, status: :ok
    else
      render json: {
        status: 'error',
        message: @registration.errors.full_messages.join(', ')
      }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.fetch(:registration_form, {})
          .permit(
            :first_name,
            :last_name,
            :email,
            :password,
            :group_code,
            :phone_number,
            :plan_id,
            :card_number,
            :month,
            :year,
            :cvc,
            :bank_name,
            :routing_number,
            :account_number,
            :start_date,
            :schedule,
            :payment_method,
            :billing_line_1,
            :billing_line_2,
            :billing_city,
            :billing_state,
            :billing_zip_code,
            :billing_phone_number,
            :stripe_token,
            :card_brand,
            orders: [:order_date, menus_orders_attributes: [:id , :menu_id, :quantity, add_ons: []]],
            addresses: %i[
              line1
              line2
              front_door
              city
              state
              zip_code
              location_at
            ]
          )
  end
end