# == Schema Information
#
# Table name: stores
#
#  id               :integer          not null, primary key
#  _id              :integer
#  _code            :string
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  home_page_images :text
#

FactoryBot.define do
  factory :store do
    _id 1
    _code "MyString"
    status 1
  end
end
