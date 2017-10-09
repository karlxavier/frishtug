class Admin::MenusController < Admin::BaseController
  before_action :set_menu, only: %i[show edit update destroy]

  # GET /menus
  # GET /menus.json
  def index
    @menus = Menu.all
    @menu_category = MenuCategory.new
    @menu_category.add_ons.build
  end

  # GET /menus/1
  # GET /menus/1.json
  def show; end

  # GET /menus/new
  def new
    @menu = Menu.new
  end

  # GET /menus/1/edit
  def edit; end

  # POST /menus
  # POST /menus.json
  def create
    @menu = Menu.new(menu_params)

    respond_to do |format|
      if @menu.save
        format.html { redirect_to [:admin, @menu], notice: 'Menu was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @menu] }
      else
        format.html { render :new }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    respond_to do |format|
      if @menu.update(menu_params)
        format.html { redirect_to [:admin, @menu], notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @menu] }
      else
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to admin_menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu
    @menu = Menu.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def menu_params
    params.fetch(:menu, {}).permit(:name, :image, :price, :unit_id, :menu_category_id, :diet_category_id)
  end
end
