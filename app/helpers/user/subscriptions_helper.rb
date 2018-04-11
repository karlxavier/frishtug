module User::SubscriptionsHelper
  def group_plan?
    return false unless current_user.plan
    current_user.plan.for_type == 'group'
  end
end
