module User::SubscriptionsHelper
  def group_plan?
    current_user.plan.for_type == 'group'
  end
end
