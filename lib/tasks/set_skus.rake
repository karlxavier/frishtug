namespace :set_skus do
  task run: :environment do
    orders = Order.all
    orders.each do |order|
      order_id = order.id.to_s
      order.sku = "SKU#{order_id.length >= 4 ? order_id : order_id.rjust(4, '0')}"
      order.save
    end
  end
end
