# == Schema Information
#
# Table name: assets
#
#  id         :bigint(8)        not null, primary key
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  file_name  :string
#

class Asset < ApplicationRecord
  has_many :menus
  has_and_belongs_to_many :stores
  mount_uploader :image, ImageUploader

  validates :file_name, presence: true, uniqueness: true
end
