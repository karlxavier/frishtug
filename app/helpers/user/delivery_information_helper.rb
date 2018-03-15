module User::DeliveryInformationHelper
  def active_badge(address)
    return nil unless address.active?
    content_tag :span, class: 'badge badge-primary badge-pill float-right' do
      address.status.titleize
    end
  end

  def set_active_badge(address)
    return nil if address.active?
    content_tag :span, class: 'badge badge-secondary badge-pill float-right' do
      "Set Active"
    end
  end
end