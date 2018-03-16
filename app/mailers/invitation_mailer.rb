class InvitationMailer < ApplicationMailer
  default from: 'invitation@frishtug.com'

  def invite(params = {})
    @sender = params[:sender]
    @recipient = params[:recipient]
    @group_code = @sender.referrer.group_code
    mail(
      to: @recipient,
      subject: "You are invited to join #{@sender.full_name}'s group"
    )
  end
end
