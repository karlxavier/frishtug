namespace :clear_inactive_users do
  task run: :environment do
    user_emails = User.pluck(:email)
    InactiveUser.where(email: user_emails).destroy_all
  end
end