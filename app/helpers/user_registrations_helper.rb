module UserRegistrationsHelper
  def menu_json_data(menu)
    menu.to_json_for_cart(only: %i[id name price tax])
  end

  def add_on_input_list(add_on, menu, type)
    id = "#{menu.name}__#{add_on.name}"
    content_tag :li do
      content_tag :label, for: id do
        check_box_tag(add_on.name, add_on.id, false, id: id, data: {
          value: add_on_json_data(add_on),
          type: 'add_ons',
          add_on_for: menu.id,
          control_type: type
        }) + add_on_name_with_price(add_on)
      end
    end
  end

  private

  def add_on_name_with_price(add_on)
    price = add_on.price.to_f
    extension = " (#{to_currency(price)})" if price > 0
    " #{add_on.name}#{extension}"
  end

  def add_on_json_data(add_on)
    add_on.to_json(only: %i[id name price])
  end
end
