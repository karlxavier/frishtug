class User::InvitationsController < User::BaseController
  def create
    InvitationMailer.send_invitation({sender: current_user, recipient: email}).deliver_now
    render json: { status: 'success', message: 'Invitation sent'}
  end

  private

  def email
    params[:email]
  end
end