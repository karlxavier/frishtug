# == Schema Information
#
# Table name: credit_cards
#
#  id         :integer          not null, primary key
#  number     :string
#  month      :integer
#  year       :integer
#  cvc        :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand      :string
#  token      :string
#  name       :string
#  stripe_id  :string
#

FactoryBot.define do
  factory :credit_card do
    number "MyString"
    month 1
    year 1
    cvc 1
    user nil
  end
end
