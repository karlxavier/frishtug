# == Schema Information
#
# Table name: add_ons_menus
#
#  id         :integer          not null, primary key
#  add_on_id  :integer
#  menu_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AddOnsMenu < ApplicationRecord
  belongs_to :add_on
  belongs_to :menu
end
