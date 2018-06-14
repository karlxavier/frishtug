class PendingChargeMailer < ApplicationMailer
  default from: 'admin@frishtug.com'

  def first_notice(user_id:, delivery_date:)
    @user = User.find(user_id)
    @delivery_date = delivery_date
    mail(to: @user.email, subject: "You still need to complete the pending charges before you get your delivery.")
  end
end
