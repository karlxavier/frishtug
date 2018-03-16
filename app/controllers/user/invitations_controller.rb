class User::InvitationsController < User::BaseController
  def create
    InvitationMailer.invite({sender: current_user, recipient: email}).deliver
    render json: { status: 'success', message: 'Invitation sent'}
  end

  private

  def email
    params[:invitee_email]
  end
end