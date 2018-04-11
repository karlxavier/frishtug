# == Schema Information
#
# Table name: user_notifications
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  timeout    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserNotification < ApplicationRecord
  belongs_to :user
end
