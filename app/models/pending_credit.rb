# == Schema Information
#
# Table name: pending_credits
#
#  id              :integer          not null, primary key
#  amount          :decimal(8, 2)
#  activation_date :datetime
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  placed_on_date  :datetime
#  order_id        :integer
#

class PendingCredit < ApplicationRecord
  belongs_to :user

  def self.activate_on(date)
    return nil unless date.present?
    where('activation_date <= ?', date.end_of_day).first
  end
end
