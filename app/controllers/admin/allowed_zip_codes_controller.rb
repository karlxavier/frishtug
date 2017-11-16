class Admin::AllowedZipCodesController < Admin::BaseController
  before_action :set_admin_allowed_zip_code, only: [:show, :edit, :update, :destroy]

  # GET /admin/allowed_zip_codes
  # GET /admin/allowed_zip_codes.json
  def index
    @admin_allowed_zip_codes = AllowedZipCode.all
  end

  # GET /admin/allowed_zip_codes/1
  # GET /admin/allowed_zip_codes/1.json
  def show
  end

  # GET /admin/allowed_zip_codes/new
  def new
    @admin_allowed_zip_code = AllowedZipCode.new
  end

  # GET /admin/allowed_zip_codes/1/edit
  def edit
  end

  # POST /admin/allowed_zip_codes
  # POST /admin/allowed_zip_codes.json
  def create
    @admin_allowed_zip_code = AllowedZipCode.new(admin_allowed_zip_code_params)

    respond_to do |format|
      if @admin_allowed_zip_code.save
        format.html { redirect_to new_admin_allowed_zip_code_path, notice: 'Allowed zip code was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @admin_allowed_zip_code] }
      else
        format.html { render :new }
        format.json { render json: @admin_allowed_zip_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/allowed_zip_codes/1
  # PATCH/PUT /admin/allowed_zip_codes/1.json
  def update
    respond_to do |format|
      if @admin_allowed_zip_code.update(admin_allowed_zip_code_params)
        format.html { redirect_to edit_admin_allowed_zip_code_path, notice: 'Allowed zip code was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_allowed_zip_code }
      else
        format.html { render :edit }
        format.json { render json: @admin_allowed_zip_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/allowed_zip_codes/1
  # DELETE /admin/allowed_zip_codes/1.json
  def destroy
    @admin_allowed_zip_code.destroy
    respond_to do |format|
      format.html { redirect_to admin_allowed_zip_codes_url, notice: 'Allowed zip code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_allowed_zip_code
      @admin_allowed_zip_code = AllowedZipCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_allowed_zip_code_params
      params.require(:allowed_zip_code).permit(:zip)
    end
end
