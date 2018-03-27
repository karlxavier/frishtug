module User::NotificationsHelper
  def display_incomplete_plan_notification
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
end