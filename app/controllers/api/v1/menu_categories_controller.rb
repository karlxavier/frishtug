class Api::V1::MenuCategoriesController < Api::V1::BaseController
  def index
    menu_categories = MenuCategory.published_menus
    render jsonapi: menu_categories
  end
end