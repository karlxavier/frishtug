namespace :process_orders do
  task run: :environment do
    ScanovatorOrdersWorker.perform_async(Time.current)
  end
end
