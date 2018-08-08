module Admin::DashboardHelper
  def show_eta(order)
    return nil unless order.eta?
    content_tag :span, class: "float-right mr-4 font-size-14" do
      order.eta
    end
  end

  def show_delivery_status(order)
    klasses = {
      received: "text-success",
      failed: "text-warning",
      address_not_found: "text-danger",
    }

    return nil unless order.delivery_status?
    span_class = "float-right mr-4 font-size-14 #{klasses[order.delivery_status.to_sym]}"
    content_tag :span, class: span_class do
      order.delivery_status.titleize
    end
  end

  def refresh_orders_btn
    button_to "Refresh",
      admin_refresh_orders_path,
      class: "btn btn-sm btn-matterhorn-outline-circled font-size-14",
      method: :get
  end

  def rollover_orders_to_scanovator_api_btn
    button_to "Rollover Orders",
      admin_scanovators_path(date: DateTime.current.to_date, format: :js),
      class: "btn btn-sm btn-matterhorn-outline-circled font-size-14",
      method: :post,
      remote: true,
      data: {
        disable_with: "Processing...",
      }
  end
end
