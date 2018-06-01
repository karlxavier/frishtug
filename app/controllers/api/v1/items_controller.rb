class Api::V1::ItemsController < Api::V1::BaseController
  def index
    if menu_category_id.present?
      menus = Menu.where(menu_category_id: menu_category_id).includes(:add_ons).all_published
    else
      menus ||= Menu.includes(:add_ons, :diet_categories).all_published
    end
    render jsonapi: menus
  end

  def show
    menu = Menu.find(params[:id])
    render jsonapi: menu
  end

  private

  def menu_category_id
    params[:category]
  end
end