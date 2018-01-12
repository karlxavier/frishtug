# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  option     :integer
#  start_date :datetime
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :schedule do
    option 1
    start_date "2017-10-24 11:50:08"
    user nil
  end
end
