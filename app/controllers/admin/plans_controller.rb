class Admin::PlansController < Admin::BaseController
  before_action :authenticate_admin!
  before_action :set_plan, only: %i[show edit update destroy]
  respond_to :js, only: %i[create update destroy]

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.order(id: :asc).page(page).per(10)
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
    flash[:success] = "#{@plan.name} has been deleted." if @plan.destroy
    respond_with(@plan)
  end

  private

  def page
    params[:page]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.require(:plan).permit(
      :name,
      :description,
      :price,
      :shipping,
      :shipping_fee,
      :interval,
      :for_type,
      :short_description,
      :shipping_note,
      :limit,
      :minimum_credit_allowed,
      :minimum_charge,
      :shipping_charge_type
    )
  end
end
