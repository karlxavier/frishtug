class Admin::MenusController < Admin::BaseController
  before_action :authenticate_admin!
  before_action :set_menu, only: %i[show edit update destroy]
  respond_to :js

  # GET /menus
  # GET /menus.json
  def index
    @menus = MenuCategory.all.includes(menus: [:unit])
    @menu_category = MenuCategory.new
    @menu_category.add_ons.build
  end

  # GET /menus/1
  # GET /menus/1.json
  def show; end

  # GET /menus/new
  def new
    @menu_category = MenuCategory.find(params[:category])
    @menu = Menu.new
    respond_with(@menu)
  end

  # GET /menus/1/edit
  def edit
    @menu_category = @menu.menu_category
  end

  # POST /menus
  # POST /menus.json
  def create
    @menu = ItemSaver.new(menu_params)
    if @menu.save(params[:commit])
      message = @menu.published? ? 'publish' : 'save as draft'
      flash[:success] = "Menu successfully #{message}."
    else
      flash[:error] = @menu.errors.full_messages
    end
    respond_with(@menu)
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    @menu = ItemSaver.new(menu_params)
    if @menu.update(params[:id], params[:commit])
      flash[:success] = 'Menu item successfully updated.'
    else
      flash[:error] = @menu.errors.full_messages
    end
    respond_with(@menu)
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    if @menu.destroy
      flash[:success] = "#{@menu.name} has been deleted!"
    else
      flash[:error] = @menu.errors
    end
    respond_with(@menu)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu
    @menu = Menu.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def menu_params
    params.fetch(:menu, {}).permit(:name, :image, :price, :unit_id, :menu_category_id, :diet_category_id, add_on_ids: [] )
  end
end
