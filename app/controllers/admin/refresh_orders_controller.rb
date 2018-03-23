class Admin::RefreshOrdersController < Admin::BaseController
  def index
    if FetchOrdersStatus.new.run
      redirect_back fallback_location: admin_dashboard_index_path
    end
  end
end