namespace :plan_limit do
  task run: :environment do
    plans = Plan.where(interval: 'month')
    plans.each_with_index do |plan, index|
      if index == 0 || index == 1
        plan.limit = 20.00
        plan.save
      end

      if index == 2
        plan.limit = 10
        plan.save
      end
    end
  end
end
