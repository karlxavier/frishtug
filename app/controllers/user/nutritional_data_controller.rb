class User::NutritionalDataController < User::BaseController
  before_action :set_nutritional_data
  respond_to :js

  def index
    @menu = Menu.find(params[:menu_id])
  end

  private

  def set_nutritional_data
    @nutritional_data = NutritionalData.find_by_menu_id(menu_id)
  end

  def menu_id
    params[:menu_id]
  end
end