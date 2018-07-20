class User::CandidatesController < User::BaseController
  def destroy
    @candidate = Candidate.find(params[:id])
    if @candidate.destroy
      redirect_to user_subscriptions_path, notice: 'Successfully remove user from the group'
    else
      flash[:error] = @candidate.errors.full_messages.join(', ')
      redirect_to user_subscriptions_path
    end
  end
end