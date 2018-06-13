# == Schema Information
#
# Table name: candidates
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)
#  referrer_id :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :candidate do
    user nil
    referrer nil
  end
end
