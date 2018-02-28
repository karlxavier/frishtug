class Admin::BlackoutDatesController < Admin::BaseController
  before_action :set_blackout_date, only: %i[edit update destroy]
  respond_to :js, only: :destroy
  def index
    @blackout_dates = BlackoutDate.all.page(page).per(10)
  end

  def new
    @blackout_date = BlackoutDate.new
    @month_names = I18n.t("date.month_names")
  end

  def edit
    @month_names = I18n.t("date.month_names")
  end

  def create
    @blackout_date = BlackoutDate.new(blackout_date_params)
    if @blackout_date.save
      redirect_back fallback_location: admin_blackout_dates_path
    end
  end

  def update
    if @blackout_date.update_attributes(blackout_date_params)
      redirect_back fallback_location: admin_blackout_dates_path
    end
  end

  def destroy
    if @blackout_date.destroy
      respond_with(@blackout_date)
    end
  end

  private

  def page
    params[:page]
  end

  def blackout_date_params
    params.require('blackout_date').permit(:month, :day, :description)
  end

  def set_blackout_date
    @blackout_date = BlackoutDate.find(params[:id])
  end
end
