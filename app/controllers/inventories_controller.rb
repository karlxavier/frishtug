class InventoriesController < ApplicationController
  before_action :set_inventory
  def index
    if @inventory.quantity >= quantity && stale?(@post)
      price = total_price(@inventory.menu.price, quantity)
      render json: { status: 'success', price: price, quantity: quantity, notes: @inventory.menu.notes}, status: :ok
    else
      render json: { status: 'error', message: 'Not enough stock' }, status: 400
    end
  end

  private

  def set_inventory
    @inventory = Inventory.find_by_menu_id(params[:menu_id])
  end

  def quantity
    params[:quantity].to_i
  end

  def total_price(quantity, price)
    (quantity * price).to_f
  end
end