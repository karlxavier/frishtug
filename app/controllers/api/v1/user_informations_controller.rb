class Api::V1::UserInformationsController < Api::V1::BaseController
	before_action :check_params!

	def index
		if @user
	      	render json: { status: 'success', data: @user }, status: :ok
	    else
	      	render json: { status: 'error', message: 'User not found!'}, status: 400
	    end
	end

	private

		def check_params!
		    unless params[:email].present?
		      	render json: { error: 'Missing email parameter' }, status: :unprocessable_entity
		    else
		    	@user = User.find_by_email(params[:email])
		    end
		end

end