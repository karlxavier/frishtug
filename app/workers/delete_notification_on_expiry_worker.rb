class DeleteNotificationOnExpiryWorker
  include Sidekiq::Worker

  def perform(notification_id)
    Notification.find(notification_id).destroy 
  end
end
