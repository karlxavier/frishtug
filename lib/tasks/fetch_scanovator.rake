namespace :fetch_scanovator do
  task run: :environment do
    first_hour = Time.parse "1:00 am"
    current_time = Time.current

    # process orders for today if the time is 1:00 am
    if current_time == first_hour
      ScanovatorOrdersWorker.perform_async(current_time.to_date)
    end

    FetchOrdersStatus.new.run
  end
end
