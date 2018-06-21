class Api::V1::TaxsController < Api::V1::BaseController
  def index
    @tax = Tax.first
    render json: { status: 'success', data: @tax.rate }, status: :ok
  end

  def calculate
    menu = Menu.find(params[:menu_id])
    add_ons = AddOn.where(id: params[:add_ons].split(',')) if params[:add_ons]
    quantity = params[:quantity].to_i
    result = []
    result << calculate_menu_tax(menu, quantity)
    result << calculate_add_ons_tax(add_ons, quantity) if params[:add_ons]
    render json: { data: result.inject(:+) || 0 }, status: :ok
  end

  private

  def calculate_menu_tax(menu, quantity)
    return 0 if menu.tax == false
    MoneyConverter.new(MoneyConverter.new(TaxCalculator.new(menu.price).calculate).to_cents * quantity).to_dollars
  end

  def calculate_add_ons_tax(add_ons, quantity)
    return 0 unless add_ons.respond_to?(:each)
    add_ons.inject(0) do |sum, add_on|
      next sum if add_on.menu_id.blank?
      menu = Menu.find(add_on.menu_id)
      next sum if menu.tax == false
      if menu.tax == true
        sum += MoneyConverter.new(MoneyConverter.new(TaxCalculator.new(menu.price).calculate).to_cents * quantity).to_dollars
        sum
      end
    end || 0
  end
end