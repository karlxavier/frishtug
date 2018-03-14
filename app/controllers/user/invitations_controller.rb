class User::InvitationController < User::BaseController
  def create

  end

  private

  def email
    params[:email]
  end
end