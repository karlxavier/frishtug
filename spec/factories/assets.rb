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

FactoryBot.define do
  factory :asset do
    image "MyString"
  end
end
