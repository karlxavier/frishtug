module User::WeeklyMealsHelper

  def user_plan_complete?
    current_user.orders.count % 20
  end

  def is_ordering?
    controller_name == 'weekly_meals' && action_name.in?(['new', 'edit'])
  end

  def copy_menu_checkbox(order_preference)
    return nil if current_user.plan.interval != 'month'
    check_box_tag(
      'copy_menu',
      true,
      order_preference&.copy_menu || false,
      class: 'form-check-input',
      data: {
        remote: true,
        url: user_copy_meals_path,
        method: "post"
      }
    ) + label_tag("copy_menu", "Copy Meal", class: 'form-check-label')
  end

  def calendar_url(date, active_this_week, active_orders, available_dates)
    url = "javascript:void(0)"
    db_date = date.to_formatted_s(:db)

    if active_this_week.flatten.include?(db_date) || active_orders.flatten.include?(db_date)
      return edit_user_weekly_meals_path(date: date)
    end

    if current_user.schedule.present?
      return "javascript:void(0)" if date.sunday? && current_user.schedule.monday_to_friday?
      return "javascript:void(0)" if date.friday? && current_user.schedule.sunday_to_thursday?
    end

    if date >= Date.current && !date.saturday?
      if current_user.subscribed?
        sched_list = %w[first second third fourth]
        list_length = available_dates.count
        sched = ''
        available_dates.each_with_index do |dates, index|
          new_index = list_length == 3 ? index + 1 : index
          if dates.include?(date)
            sched = sched_list[new_index]
          end
        end
        url = new_user_weekly_meal_path(date: date, schedule: sched) if sched.present?
      else
        url = new_user_weekly_meal_path(date: date)
      end
    end

    url
  end

  def calendar_classes(date, active_this_week, active_orders)
    return nil unless current_user.plan
    classes = []
    classes.push 'font-weight-bold font-italic font-size-18' if date.today?
    classes.push 'active' if active_this_week.present? && active_this_week[0].include?(date.to_s)
    multiple_colored_weeks(classes, active_orders, date) if current_user.plan.interval == 'month'
    single_colored_weeks(classes, active_orders, date) if current_user.plan.interval != 'month'
    classes.push 'disabled' if date < Date.current || date.saturday?
    if current_user.schedule.present?
      return "disabled" if date.sunday? && current_user.schedule.monday_to_friday?
      return "disabled" if date.friday? && current_user.schedule.sunday_to_thursday?
    end
    classes.join(' ')
  end

  def back_to_index_link(text)
    link_to user_weekly_meals_path, class: 'dark-font-color' do
      "<i class='fa fa-chevron-left'></i> #{text}".html_safe
    end
  end

  def category_link(date, category, category_id)
    is_active = 'active' if category_id.to_i == category.id

    link_to category.name.titleize,
      request.params.merge(category: category.id),
      class: "nav-link btn btn-outline--category mx-2 #{is_active}"
  end

  def add_on_input_list_weekly(add_on, menu, date, order)
    id = format_id(menu, add_on, date)
    klass = 'menu_add_ons'

    content_tag :li do
      content_tag :label, for: id do
        check_box_tag(
          add_on.name,
          add_on.id,
          is_checked?(order, menu.id, add_on.id),
          id: id,
          class: klass,
          data: {
            date: date,
            menu_id: menu.id
        }) + " #{add_on.name_with_price}"
      end
    end
  end

  def has_tax(menus_orders)
    menus_orders.any? { |order| order.menu.tax }
  end

  def total_tax(order)
    OrderCalculator.new(order).total_tax
  end

  def total_menu_price(order)
    price = order.menu_price * order.quantity
    add_ons_prices = AddOn.pluck_prices(:id)
    add_on_price = order.add_ons.map { |a| add_ons_prices[a.to_i] || 0 }.inject(:+) || 0
    price += add_on_price * order.quantity
  end

  def display_warning(total)
    return unless current_user.subscribed?
    plan_limit = current_user.plan.limit
    plan_minimum = current_user.plan.minimum_credit_allowed
    remaining_credit = (plan_limit - total).round(2)

    if total > plan_limit
      return content_tag :small, class: 'alert alert-warning d-flex', style: 'font-size: 9px; width: 100%' do
        content_tag(:i, nil, class: 'fa fa-exclamation-circle font-size-24 pr-1') + <<-EOF
        You have exceeded your plan limit of $ #{plan_limit}.
        Any excess will be charge directly to your account.
          EOF
      end
    end

    if remaining_credit > 0 && total >= plan_minimum
      return content_tag :small, class: 'alert alert-info d-flex', style: 'font-size: 9px; width: 100%' do
        content_tag(:i, nil, class: 'fa fa-info-circle font-size-24 pr-1') + <<-EOF
        Order not finished, because you still have $ #{remaining_credit}
        credits available.
          EOF
      end
    end
  end

  def display_pending_credits(order)
    return nil unless order.present?
    pending_credit = current_user.pending_credits.activate_on(order.placed_on)
    return nil unless pending_credit.present?
    content_tag :small, class: 'alert alert-info d-flex', style: 'font-size: 9px; width: 100%' do
      content_tag(:i, nil, class: 'fa fa-exclamation-circle font-size-24 pr-1') + <<-EOF
       You have #{to_currency(pending_credit.amount)} of credits available. Your excess will be deducted to your pending credit.
      EOF
    end
  end

  private

  def single_colored_weeks(classes, active_orders, date)
    flattened_weeks = active_orders.flatten
    classes.push 'active_not_current_week' if flattened_weeks.include?(date.to_s)
  end

  def multiple_colored_weeks(classes, active_orders, date)
    classes.push 'active_not_current_first_week' if active_orders[0]&.include?(date.to_s)
    classes.push 'active_not_current_second_week' if active_orders[1]&.include?(date.to_s)
    classes.push 'active_not_current_third_week' if active_orders[2]&.include?(date.to_s)
    classes.push 'active_not_current_fourth_week' if active_orders[3]&.include?(date.to_s)
  end

  def is_checked?(order, menu_id, add_on_id)
    order.menus_orders.where(menu_id: menu_id)
    .first&.add_ons&.include?(add_on_id.to_s)
  end

  def format_id(menu, add_on, date)
    "#{menu.name}__#{add_on.name.underscore}__#{date.split('-').join}"
  end
end
