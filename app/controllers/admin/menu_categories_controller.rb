class Admin::MenuCategoriesController < Admin::BaseController
  before_action :set_menu_category, only: %i[show edit update destroy]
  respond_to :js, only: %i[create destroy update]
  respond_to :html, only: :create
  # GET /menu_categories
  # GET /menu_categories.json
  def index
    @menu_categories = MenuCategory.includes(:add_ons)
  end

  # GET /menu_categories/1
  # GET /menu_categories/1.json
  def show; end

  # GET /menu_categories/new
  def new
    @menu_category = MenuCategory.new
    @menu_category.add_ons.build
  end

  # GET /menu_categories/1/edit
  def edit; end

  # POST /menu_categories
  # POST /menu_categories.json
  def create
    @menu_category = MenuCategory.new(menu_category_params)
    if @menu_category.save
      flash[:success] = 'Category save successfully.'
    else
      flash[:error] = @menu_category.errors.full_messages
    end
    respond_with(@menu_category)
  end

  # PATCH/PUT /menu_categories/1
  # PATCH/PUT /menu_categories/1.json
  def update
    if @menu_category.update(menu_category_params)
      flash[:success] = 'Category save successfully.'
    else
      flash[:error] = @menu_category.errors.full_messages
    end
    respond_with(@menu_category)
  end

  # DELETE /menu_categories/1
  # DELETE /menu_categories/1.json
  def destroy
    if @menu_category.destroy
      flash[:success] = "#{@menu_category.name} has been deleted!"
    else
      flash[:error] = "#{@menu_category.name} failed to delete!"
    end
    respond_with(@menu_category)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu_category
    @menu_category = MenuCategory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def menu_category_params
    params.require(:menu_category)
      .permit(:name, :display_order, :part_of_plan, add_ons_attributes: [:id, :name, :price, :_destroy])
  end
end
