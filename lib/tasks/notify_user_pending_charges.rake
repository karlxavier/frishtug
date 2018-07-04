namespace :notify_user_pending_charges do
  desc "Notify users with pending charges"
  task run: :environment do
    NotifyWorker.perform_async
  end
end
