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

FactoryBot.define do
  factory :assets_store do
    store nil
    asset nil
  end
end
