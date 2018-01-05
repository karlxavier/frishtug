class Admin::ImportMenusController < Admin::BaseController
  def index
    if params[:download] == 'true'
      send_file(
        "#{Rails.root}/public/template.csv",
        filename: "csv_template.csv",
        type: 'text/csv'
      )
    end
  end

  def import
    @document = Document.new(file: params[:file])
    if @document.save
      ImportWorker.perform_async(@document.id)
      message = "File successfully uploaded and will be processed in the background"
    else
      message = @menu_importer.errors.full_messages.join(', ')
    end
    redirect_back fallback_location: :back, notice: message
  end
end
