module Admin::DashboardHelper
  def rollover_orders_to_scanovator_api_btn
    button_to "Rollover Orders",
      admin_scanovators_path(date: date_tomorrow, format: :js),
      class: 'btn btn-sm btn-brown-outline-circled font-size-14',
      method: :post,
      remote: true,
      data: {
        disable_with: 'Processing...'
      }
  end

  private

  def date_tomorrow
    DateTime.current.tomorrow.to_date
  end
end
