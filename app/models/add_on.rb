# == Schema Information
#
# Table name: add_ons
#
#  id               :integer          not null, primary key
#  name             :string
#  menu_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  price            :decimal(8, 2)
#

# Class names
# id name menu_category_id
class AddOn < ApplicationRecord
  has_and_belongs_to_many :menus
  belongs_to :menu_category
  validates :name, :menu_category_id, presence: true

  def name_with_price
    "#{self.name} #{ "($ #{self.price})" if self.price > 0}".strip
  end
end
