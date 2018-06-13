# == Schema Information
#
# Table name: pending_credits
#
#  id              :bigint(8)        not null, primary key
#  amount          :decimal(8, 2)
#  activation_date :datetime
#  user_id         :bigint(8)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  placed_on_date  :datetime
#  order_id        :bigint(8)
#

class PendingCredit < ApplicationRecord
  belongs_to :user
  belongs_to :order, optional: true

  def self.activate_on(date)
    return nil unless date.present?
    where('activation_date <= ?', date.end_of_day)
  end
end
