class ContactUsController < ApplicationController
  def create
    @contact_us_message = ContactUsMessage.new(contact_us_params)
    if @contact_us_message.save
      ContactUsMailer.send_message(@contact_us_message.id).deliver
      redirect_back fallback_location: :back, notice: 'Message sent!'
    else
      redirect_back fallback_location: :back, notice: @contact_us_message.errors.full_messages.join(', ')
    end
  end

  private

  def contact_us_params
    params.require(:contact_us_message).permit(:first_name, :last_name, :email, :message)
  end
end
