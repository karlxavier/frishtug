class Admin::ImportMenusController < Admin::BaseController
  def index; end

  def import
    @menu_importer = MenuImporter.new(params[:file])
    if @menu_importer.run
      flash[:success] = successfull_message
    else
      flash[:error] = @menu_importer.errors.full_messages.join(', ')
    end
    redirect_back fallback_location: :back
  end

  private

  def successfull_message
    "Successfully imported #{@menu_importer.size} #{'row'.pluralize(@menu_importer.size)}"
  end
end
