namespace :destroy_users do
  task run: :environment do
    User.all.destroy_all
  end
end