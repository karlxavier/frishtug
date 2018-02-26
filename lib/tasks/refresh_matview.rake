namespace :refresh_matview do
  task run: :environment do
    ItemsWithStock.refresh
  end
end
