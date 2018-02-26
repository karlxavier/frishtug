module UserRegistrationsHelper
  def reg_legend_marker(menu)
    return nil unless menu.diet_categories.present?
    klass = 'fa fa-star diet-icons'
    menu.diet_categories.map do |name|
      content_tag(:span, nil, class: "#{klass} #{name.parameterize}", title: name, data: {
                    toggle: 'tooltip',
                    placement: 'top'
                  })
    end.join(' ').html_safe
  end

  def step_activator(current_index, index_to_activate)
    return 'btn-brown active' if current_index == index_to_activate
    return 'btn-primary' if current_index < index_to_activate
    'btn-secondary disabled text-muted'
  end

  def menu_json_data(menu)
    menu.to_json_for_cart(only: %i[id name price tax])
  end

  def add_on_input_list(add_on, menu, type)
    id = "#{menu.name}__#{add_on.name.underscore}__#{type}"
    content_tag :li do
      content_tag :label, for: id do
        check_box_tag(add_on.name, add_on.id, false, id: id, data: {
                        value: add_on_json_data(add_on),
                        type: 'add_ons',
                        add_on_for: menu.menu_id,
                        control_type: type
                      }) + " #{add_on.name_with_price}"
      end
    end
  end

  private

  def add_on_json_data(add_on)
    add_on.json_string
  end
end
