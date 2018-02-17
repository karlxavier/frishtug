# == Schema Information
#
# Table name: order_preferences
#
#  id         :integer          not null, primary key
#  copy_menu  :boolean
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderPreference < ApplicationRecord
  belongs_to :user
end
