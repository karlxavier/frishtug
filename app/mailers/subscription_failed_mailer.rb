class SubscriptionFailedMailer < ApplicationMailer
  default from: 'admin@frishtug.com'

  def notify(user_id:, error_message:, attempt_time:)
    @user = User.find(user_id)
    @error_message = error_message
    @attempt_time = attempt_time
    mail(to: @user.email, subject: "Renewal Failed")
  end
end
