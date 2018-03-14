class InvitationMailer < ApplicationMailer
  default from: 'invitation@frishtug.com'

  def send_invitation(params = {})
    @sender = params[:sender]
    @recipient = params[:recipient]
    mail(to: @recipient, subject: "#{@sender.full_name} has invited you to sign up on frishtug")
  end
end
