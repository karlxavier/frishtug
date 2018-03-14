# == Schema Information
#
# Table name: items_with_stocks
#
#  menu_id            :integer
#  name               :string
#  price              :decimal(8, 2)
#  published          :boolean
#  unit_size          :integer
#  unit_id            :integer
#  item_number        :string
#  tax                :boolean
#  description        :text
#  asset_id           :integer
#  quantity           :integer
#  menu_category_id   :integer
#  menu_category_name :string
#  display_order      :integer
#  diet_categories    :string           is an Array
#

class ItemsWithStock < ActiveRecord::Base
  belongs_to :menu
  belongs_to :menu_category
  belongs_to :asset
  belongs_to :unit

  class << self
    def grouped(attribute)
      Rails.cache.fetch([self, "grouped"], expires_in: 12.hours) do
        includes(
          :unit,
          :asset,
          :menu_category,
          menu: :add_ons
        ).order('display_order ASC').group_by(&attribute.to_sym)
      end
    end

    def refresh
      Scenic
          .database
          .refresh_materialized_view(table_name, concurrently: false, cascade: false)
    end
  end

  def to_json_for_cart(**args)
    menu.to_json_for_cart(**args)
  end

  def add_ons
    menu.add_ons
  end

  def readonly?
    true
  end
end
