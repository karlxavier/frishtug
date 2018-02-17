# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  file       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :document do
    file "MyString"
  end
end
