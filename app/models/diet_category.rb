# == Schema Information
#
# Table name: diet_categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Column names
# id name
class DietCategory < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
  has_and_belongs_to_many :menus
end
