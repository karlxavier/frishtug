class Api::V1::ItemsController < Api::V1::BaseController
  def index
    menus = Menu.includes(:add_ons).all_published
    render jsonapi: menus
  end

  def show
    menu = Menu.find(params[:id])
    render jsonapi: menu
  end
end