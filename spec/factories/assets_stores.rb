# == Schema Information
#
# Table name: assets_stores
#
#  id         :bigint(8)        not null, primary key
#  store_id   :bigint(8)
#  asset_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :assets_store do
    store nil
    asset nil
  end
end
