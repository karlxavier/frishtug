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

FactoryBot.define do
  factory :asset do
    image "MyString"
  end
end
