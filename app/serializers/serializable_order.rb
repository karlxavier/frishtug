class SerializableOrder < JSONAPI::Serializable::Resource
  type 'orders'
  attributes  :placed_on,
              :eta,
              :delivered_at,
              :status,
              :remarks,
              :order_date,
              :series_number,
              :sku,
              :delivery_status,
              :payment_details,
              :route_started,
              :payment_status,
              :menus_orders
end