class NotifyWorker
  include Sidekiq::Worker

  def perform
    pending_charges = Ledger.where.not(status: :paid)
    user_ids = pending_charges.pluck(:user_id)
    return false if user_ids.size == 0

    placed_ons = {}
    pending_charges.group_by(&:user_id).each do |user_id, l|
      placed_ons[user_id] = Order.where(id: l.pluck(:order_id)).pluck(:placed_on)
    end

    User.where(id: user_ids).find_each do |user|
      PendingChargeMailer.daily_notify(user_id: user.id, dates: placed_ons[user.id]).deliver
    end
  end
end
