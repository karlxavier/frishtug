module User::WeeklyMealsHelper
  def back_to_index_link(text, css_class)
    link_to text, user_weekly_meals_path, class: css_class
  end

  def category_link(date, category, category_id)
    url_extension = action_name == 'edit' ? 'meals' : 'meal'
    url = "#{action_name}_user_weekly_#{url_extension}_path"
    is_active = 'active' if category_id.to_i == category.id

    link_to category.name.titleize,
            public_send(url, date: date, category: category.id),
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

  def total_menu_price(order)
    price = order.menu_price * order.quantity
    add_on_price = AddOn.where(id: order.add_ons).map(&:price).inject(:+) || 0
    price += add_on_price * order.quantity
  end

  private

  def is_checked?(order, menu_id, add_on_id)
    order.menus_temp_orders.where(menu_id: menu_id)
      .first&.add_ons&.include?(add_on_id.to_s)
  end

  def format_id(menu, add_on, date)
    "#{menu.name}__#{add_on.name.underscore}__#{date.split('-').join}"
  end
end
