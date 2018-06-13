# == Schema Information
#
# Table name: user_notifications
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  body       :text
#  timeout    :integer
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uniq_id    :string
#

class UserNotification < ApplicationRecord
  belongs_to :user
end
