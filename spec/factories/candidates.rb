# == Schema Information
#
# Table name: candidates
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  referrer_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :candidate do
    user nil
    referrer nil
  end
end
