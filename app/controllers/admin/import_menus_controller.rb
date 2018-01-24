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
      flash[:success] = message
    else
      flash[:error] = @document.errors.full_messages.join(', ')
    end

    redirect_back fallback_location: :back
  end

  private

  def file
    params[:file]
  end
end
