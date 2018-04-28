namespace :charge_group do
  desc "Task to check if users in a group has 5 people"
  desc "If group is less than 5 people it will charge the group for $5 shipping on the delivery of their meal"

  task run: :environment do
    current_time = Time.current
    group_plan_id = Plan.where(for_type: 'group').pluck(:id)
    users_in_a_group = User.where(plan_id: group_plan_id)
    range = DateRange.new(current_time.beginning_of_day, current_time.end_of_day)

    orders = Order.placed_between?(range)
                  .where(user_id: users_in_a_group.pluck(:id))

    puts "Charge group start #{current_time}"
    puts "Chargin user's with ids #{orders.pluck(:user_id)} with order ids of #{orders.pluck(:id)}"
    orders.find_each(batch_size: 50) do |order|
      ChargeGroup.call(order.user, order)
    end
    puts "Finish in #{(Time.current - current_time) * 1000.0} ms"
  end
end
