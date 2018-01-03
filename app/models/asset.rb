# == Schema Information
#
# Table name: assets
#
#  id             :integer          not null, primary key
#  image          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  assetable_type :string
#  assetable_id   :integer
#

class Asset < ApplicationRecord
  has_many :menus
  has_and_belongs_to_many :stores
  mount_uploader :image, ImageUploader
end
