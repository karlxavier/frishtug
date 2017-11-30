# == Schema Information
#
# Table name: units
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Class names
# id name
class Unit < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  has_many :menus
  include NameSearchable
end
