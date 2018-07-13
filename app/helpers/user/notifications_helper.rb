module User::NotificationsHelper
  def display_incomplete_plan_notification
    return nil unless current_user.plan
    return nil if current_user.plan.interval != 'month'
    return nil if current_user.orders.count >= 20
    days = 20 - current_user.orders.processing.count
    remaining_weeks = days / 5
    remaining_days = days % 5
    orders_to_complete = "#{pluralize(remaining_weeks, 'week')} #{ "and " + pluralize(remaining_days, 'day') unless remaining_days.zero?}"

    content_tag :div, class: 'alert alert-info' do
      ("You must complete your plan, you still have #{orders_to_complete} to fill " +
      link_to('click here', user_weekly_meals_path)).html_safe
    end
  end

  def display_incomplete_group_notification
    return nil unless current_user.in_a_group?
    return nil if current_user.is_entitled_for_discount?
    if current_user.members.size < 4
      return content_tag :div, class: 'alert alert-info' do
        "You must complete your group to avail group discount. You only have #{pluralize(current_user.total_members + 1, 'person')} in your group."
      end
    end

    unless current_user.equal_group_address?
      return content_tag :div, class: 'alert alert-info' do
        "You're members must have the same active address as your address for your group to not be charge for shipping"
      end
    end
  end

  def display_pending_credits_notification
    return nil unless current_user.subscribed?
    credits = current_user.ledgers.unpaid
    return nil unless credits.present?
    content_tag :div, class: 'alert alert-danger font-size-18' do
      ("You have pending charges that you still need to pay " +
      link_to('click here.', user_ledgers_path)).html_safe
    end
  end
end