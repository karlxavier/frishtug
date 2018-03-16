class MenusController < ApplicationController
  def index
    @menus_with_category = ItemsWithStock.grouped(:menu_category_name)
    render json: {
      items: @menus_with_category
    }, status: :ok
  end
end