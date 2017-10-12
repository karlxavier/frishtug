# == Schema Information
#
# Table name: menu_add_ons
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  add_on_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Join table for menu and add-ons
# Class names
# id menu_id add_on_id
class MenuAddOn < ApplicationRecord
  belongs_to :menu
  belongs_to :add_on
  validates :menu_id, :add_on_id, presence: true
end
