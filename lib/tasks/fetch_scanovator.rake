namespace :fetch_scanovator do
  task run: :environment do
    FetchOrdersStatus.new.run
  end
end
