# == Schema Information
#
# Table name: nutritional_data
#
#  id         :bigint(8)        not null, primary key
#  menu_id    :bigint(8)
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :nutritional_datum, class: 'NutritionalData' do
    menu nil
  end
end
