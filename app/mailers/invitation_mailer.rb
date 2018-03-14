class InvitationMailer < ApplicationMailer
  default from: 'invitation@frishtug.com'

  def send_invitation(params = {})
    @sender = params[:sender]
    @recipient_email = params[:recipient_email]
    mail(to: @recipient_email, subject: "#{@sender.full_name} has invited you to sign up on frishtug")
  end
end
