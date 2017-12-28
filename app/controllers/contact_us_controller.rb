class ContactUsController < ApplicationController
  def create
    ContactUsMailer.send_message(contact_us_params).deliver
    redirect_back fallback_location: :back, notice: 'Message sent!'
  end

  private

  def contact_us_params
    params.require(:contact_us).permit(:first_name, :last_name, :email, :message)
  end
end
