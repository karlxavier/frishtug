class Admin::ContactUsMessagesController < Admin::BaseController
  def index
    @contact_us_messages = ContactUsMessage.all.page(page).per(20)
  end

  def show
    @contact_us_message = ContactUsMessage.find(params[:id])
  end

  private
  
  def page
    params[:page]
  end
end