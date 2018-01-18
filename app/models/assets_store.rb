# == Schema Information
#
# Table name: assets_stores
#
#  id         :integer          not null, primary key
#  store_id   :integer
#  asset_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AssetsStore < ApplicationRecord
  belongs_to :store
  belongs_to :asset
end
