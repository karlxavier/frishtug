class PagesController < ApplicationController
  include HighVoltage::StaticPage
  before_action :set_plans

  private

  def set_plans
    @plans = Plan.allsss.sort if params[:id] == 'plans'
  end
end
