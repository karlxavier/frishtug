class DeleteNotificationOnExpiryWorker
  include Sidekiq::Worker

  def perform(notification_id)
    Notification.find_by_id(notification_id).destroy
  end
end
