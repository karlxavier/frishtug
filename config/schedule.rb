set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every 1.day, at: '12am' do
  rake 'process_orders:run'
end

every 1.day, at: '11pm' do
  rake 'perform_renewal:run'
end


every 1.day, at: '1am' do
  rake 'notify_user_pending_charges:run'
end