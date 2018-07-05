namespace :update_user_expiry do
  desc "Updates user subscription_expires_at"
  task run: :environment do
    subscribed_users =
      User.joins(:plan).merge(Plan.where.not(interval: [nil, '']))
      subscribed_users.find_each do |user|
        user.save
      end
  end
end
