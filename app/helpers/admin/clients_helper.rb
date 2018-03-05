module Admin::ClientsHelper

  def user_order_edit_link(order)
    cant_edit = '<em class="text-muted font-size-12">Cannot Edit</em>'
    return cant_edit.html_safe if order.placed_on < Time.current
    link_to edit_admin_order_path(order_id: order.id), class: 'chocolate-font-color' do
      content_tag(:i, nil, class: 'fa fa-edit') + "Edit"
    end
  end

  def user_plan_details(user)
    "Plan: #{user.plan_name} (#{to_currency(user.plan_price)})"
  end

  def user_email(user)
    mail_to user.email, class: 'chocolate-font-color' do
      content_tag(:i, nil, class: 'fa fa-envelope') + " #{user.email}"
    end
  end

  def user_phone_number(user)
    phone = user.contact_number_phone_number
    link_to phone, class: 'chocolate-font-color' do
      content_tag(:i, nil, class: 'fa fa-phone') + " #{phone}"
    end
  end

  def user_address(user)
    address = <<-EOF
      <i class="fa fa-address-card" aria-hidden="true"></i>
      #{user.full_address}
    EOF
    address.html_safe
  end

  def user_order_details_link(order)
    link_to admin_order_path(order), class: 'btn chocolate-font-color btn-sm' do
      content_tag(:i, nil, class: 'fa fa-eye') + " View"
    end
  end

  def user_number_of_orders(user)
    link_to "javascript:void(0)", class: 'chocolate-font-color', title: 'Number Of Orders' do
      content_tag(:i, nil, class: 'fa fa-cubes') + " #{pluralize(user.orders.count, 'order')}"
    end
  end
end
