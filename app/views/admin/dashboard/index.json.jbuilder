json.array! @active_orders do |order|
  json.(order, :id, :placed_on, :series_number, :sku, :delivery_status, :remarks, :updated_at)

  json.user do
    json.full_name order.user.full_name
    json.email order.user.email
    json.address order.user.active_address, :line1, :line2, :front_door, :city, :state, :zip_code
  end

  json.items order.menus_orders do |item|
    json.id item.id
    json.name item.menu.name
    json.quantity item.quantity
    json.price item.menu.price * item.quantity

    json.add_ons item.add_ons do |id|
      add_on = AddOn.find(id)
      json.id add_on.id
      json.name add_on.name
      json.quantity item.quantity
      json.price add_on.price * item.quantity
    end
  end

  json.sub_total order.sub_total
  json.tax order.total_tax
  json.shipping_fee order.shipping_fee unless order.user.subscribed?
  json.total order.total
end