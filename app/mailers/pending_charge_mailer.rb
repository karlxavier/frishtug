class PendingChargeMailer < ApplicationMailer
  default from: 'admin@frishtug.com'

  def first_notice(user_id:, delivery_date:)
    @user = User.find(user_id)
    @delivery_date = delivery_date
    mail(to: @user.email, subject: "You still need to complete the pending charges before you get your delivery.")
  end

  def notify(user_id:, order_id:)
    @user = User.find(user_id)
    @order = Order.find(order_id)
    mail(to: @user.email, subject: "Pending Charge Notice")
  end

  def daily_notify(user_id:, dates:)
    @user = User.find(user_id)
    @dates = dates
    mail(to: @user.email, subject: "Pending Charge Notice")
  end
end
