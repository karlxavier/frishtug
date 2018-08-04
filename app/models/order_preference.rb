# frozen_string_literal: true

# == Schema Information
#
# Table name: order_preferences
#
#  id         :bigint(8)        not null, primary key
#  copy_menu  :boolean
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderPreference < ApplicationRecord
  belongs_to :user
end
