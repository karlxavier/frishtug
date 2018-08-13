class Admin::ContactUsMessagesController < Admin::BaseController
  helper_method :sort_column, :sort_direction

  def index
    @contact_us_messages = ContactUsMessage.all.order("#{sort_column} #{sort_direction}").page(page).per(20)
  end

  def show
    @contact_us_message = ContactUsMessage.find(params[:id])
  end

  private
  
  def page
    params[:page]
  end

  def sort_column
    ContactUsMessage.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end