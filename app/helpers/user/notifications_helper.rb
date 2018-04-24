module User::NotificationsHelper
  def display_incomplete_plan_notification
    return nil unless current_user.plan
    return nil if current_user.plan.interval != 'month'
    return nil if current_user.orders.count >= 20
    remaining_days = 20 - current_user.orders.count
    remaining_weeks = remaining_days / 5
    orders_to_complete = remaining_weeks.zero? ?
      pluralize(remaining_days, 'day') : pluralize(remaining_weeks, 'week')
    content_tag :div, class: 'alert alert-info' do
      ("You must complete your plan, you still have #{orders_to_complete} to fill " +
      link_to('click here', user_weekly_meals_path)).html_safe
    end
  end

  def display_incomplete_group_notification
    return nil unless current_user.in_a_group?
    return nil if current_user.is_entitled_for_discount?
    content_tag :div, class: 'alert alert-info' do
      "You must complete your group to avail group discount. You only have #{pluralize(current_user.total_members + 1, 'person')} in your group."
    end
  end
end