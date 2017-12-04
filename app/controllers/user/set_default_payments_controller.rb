class User::SetDefaultPaymentsController < User::BaseController
  def create
    if current_user.set_default_source(params[:source])
      redirect_to user_payment_informations_url, 
        notice: 'Successfully set to default'
    end
  end
end