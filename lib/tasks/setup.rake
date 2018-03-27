namespace :setup do
  task plans: :environment do
    option_3 = Plan.find_by_name('Option 3')

    option_3.update_attributes(shipping_billed_once: true)
  end
end