class Admin::PlansController < Admin::BaseController
  before_action :authenticate_admin!
  before_action :set_plan, only: %i[show edit update destroy]
  respond_to :js, only: [:create, :update]

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.all
  end

  # GET /plans/1
  # GET /plans/1.json
  def show; end

  # GET /plans/new
  def new
    @plan = Plan.new
  end

  # GET /plans/1/edit
  def edit; end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      flash[:success] = "#{@plan.name} was successfully created."
    else
      flash[:error] = @plan.errors
    end
    respond_with(@plan)
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    if @plan.update(plan_params)
      flash[:success] = "#{@plan.name} has been updated."
    else
      flash[:error] = @plan.errors
    end
    respond_with(@plan)
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to plans_url, notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.fetch(:plan, {}).permit(:name)
  end
end
