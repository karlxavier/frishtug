class ContactUsController < ApplicationController
  def create
    if is_complete?
      ContactUsMailer.send_message(contact_us_params).deliver
      redirect_back fallback_location: :back, notice: 'Message sent!'
    else
      redirect_back fallback_location: :back, notice: 'Message not sent! Please fill up all the fields'
    end
  end

  private

  def is_complete?
    contact_us_params[:first_name].present? &&
    contact_us_params[:last_name].present? &&
    contact_us_params[:email].present? &&
    contact_us_params[:message].present?
  end

  def contact_us_params
    params.require(:contact_us).permit(:first_name, :last_name, :email, :message)
  end
end
