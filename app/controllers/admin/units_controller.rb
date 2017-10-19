class Admin::UnitsController < Admin::BaseController
  before_action :set_unit, only: %i[show edit update destroy]
  respond_to :js, only: [:destroy, :create, :update]
  # GET /units
  # GET /units.json
  def index
    @units = Unit.all
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit; end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)
    if @unit.save
      flash[:success] = "#{@unit.name} has been save"
    else
      flash[:error] = @unit.errors
    end
    respond_with(@unit)
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to [:admin, @unit], notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @unit] }
      else
        format.html { render :edit }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    if @unit.destroy
      flash[:success] = "#{@unit.name} has been deleted!"
    else
      flash[:error] = "#{@unit.name} failed to delete"
    end
    respond_with(@unit)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_unit
    @unit = Unit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def unit_params
    params.fetch(:unit, {}).permit(:name)
  end
end
