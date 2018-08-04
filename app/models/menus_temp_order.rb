# frozen_string_literal: true

# == Schema Information
#
# Table name: menus_temp_orders
#
#  id            :bigint(8)        not null, primary key
#  menu_id       :bigint(8)
#  temp_order_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  quantity      :integer          default(0)
#  add_ons       :string           default([]), is an Array
#

class MenusTempOrder < ApplicationRecord
  belongs_to :menu
  belongs_to :temp_order

  delegate :name, :id, :price, to: :menu, prefix: true, allow_nil: true

  def add_ons_list
    return nil if add_ons.blank?
    "<small>(#{add_ons.map { |a| AddOn.where(id: a).first&.name }.join(', ')})</small>".html_safe
  end
end
