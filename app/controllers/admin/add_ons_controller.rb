class Admin::AddOnsController < Admin::BaseController
  def index
    menu = Menu.find(params[:id])
    if menu.add_ons.present?
      render json: {
        status: 'success',
        add_ons: menu.add_ons.to_json(except: [:created_at, :updated_at])
      }, status: :ok
    else
      render json: { status: 'error', message: 'No add ons for menu' }, status: :ok
    end
  end
end