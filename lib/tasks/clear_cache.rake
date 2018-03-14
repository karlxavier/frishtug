namespace :clear_cache do
  task run: :environment do
    Rails.cache.clear
  end
end