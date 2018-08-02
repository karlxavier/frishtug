# == Schema Information
#
# Table name: notifications
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  body       :text
#  expiry     :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ApplicationRecord
  after_save :delete_on_expiry

  private

  def delete_on_expiry
    DeleteNotificationOnExpiryWorker.perform_at(self.expiry, self.id)
  end
end
