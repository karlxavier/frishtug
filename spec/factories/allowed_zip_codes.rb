# == Schema Information
#
# Table name: allowed_zip_codes
#
#  id         :bigint(8)        not null, primary key
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint(8)
#

FactoryBot.define do
  factory :allowed_zip_code do
    zip "MyString"
  end
end
