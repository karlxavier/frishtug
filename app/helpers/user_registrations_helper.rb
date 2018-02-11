module UserRegistrationsHelper
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
          add_on_for: menu.id,
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
