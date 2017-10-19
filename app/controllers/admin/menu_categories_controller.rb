class Admin::MenuCategoriesController < Admin::BaseController
  before_action :set_menu_category, only: %i[show edit update destroy]
  respond_to :js, only: %i[create destroy]
  respond_to :html, only: :create
  # GET /menu_categories
  # GET /menu_categories.json
  def index
    @menu_categories = MenuCategory.all
  end

  # GET /menu_categories/1
  # GET /menu_categories/1.json
  def show; end

  # GET /menu_categories/new
  def new
    @menu_category = MenuCategory.new
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
    respond_to do |format|
      if @menu_category.update(menu_category_params)
        format.html { redirect_to [:admin, @menu_category], notice: 'Menu category was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @menu_category] }
      else
        format.html { render :edit }
        format.json { render json: @menu_category.errors, status: :unprocessable_entity }
      end
    end
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
    params.fetch(:menu_category, {}).permit(:name, addons_attributes: %i[id name _destroy])
  end
end
