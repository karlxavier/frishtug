# frozen_string_literal: true

# == Schema Information
#
# Table name: schedules
#
#  id         :bigint(8)        not null, primary key
#  option     :integer
#  start_date :datetime
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Schedule < ApplicationRecord
  enum option: %i[monday_to_friday sunday_to_thursday]
  belongs_to :user, required: false
  # before_update :check_orders

  def check_orders
    unless user.orders.all?(&:completed?)
      errors.add(:base, 'You can change your schedule after completing your plan!')
      throw :abort
    end
  end
end
