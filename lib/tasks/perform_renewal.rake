namespace :perform_renewal do
  desc "Renewal for subscribe users"
  task run: :environment do
    RenewalWorker.perform_async
  end
end
