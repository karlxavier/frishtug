# == Schema Information
#
# Table name: add_ons
#
#  id               :integer          not null, primary key
#  name             :string
#  menu_category_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

# Class names
# id name menu_category_id
class AddOn < ApplicationRecord
  belongs_to :menu_category
  validates :name, :menu_category_id, presence: true
end
