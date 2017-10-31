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
#

class CreditCard < ApplicationRecord
  belongs_to :user
  has_one :address, as: :addressable
end
