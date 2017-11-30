# == Schema Information
#
# Table name: allowed_zip_codes
#
#  id         :integer          not null, primary key
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :allowed_zip_code do
    zip "MyString"
  end
end
