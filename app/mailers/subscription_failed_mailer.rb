class SubscriptionFailedMailer < ApplicationMailer
  default from: 'admin@frishtug.com'

  def notify(user_id:, error_message:)
    @user = User.find(user_id)
    @error_message = error_message
    mail(to: @user.email, subject: "Renewal Failed")
  end
end
