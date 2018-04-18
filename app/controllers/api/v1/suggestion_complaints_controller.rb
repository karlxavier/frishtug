class Api::V1::SuggestionComplaintsController < Api::V1::BaseController

	def create
		@suggestion_complaint = SuggestionComplaint.new(sc_params)
		if @suggestion_complaint.save
			render json: { status: 'success', message: 'Thank you for your message!' }, status: :ok
		else
			render json: {
		        status: 'error',
		        message: @suggestion_complaint.errors.full_messages.join(', ')
		    }, status: :unprocessable_entity
		end
	end

	private

		def sc_params
			params.require(:suggestion_complaint).permit(:type, :email, :message)
		end

end