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
#

class CreditCard < ApplicationRecord
  belongs_to :user
  has_one :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true
  validates :number, :month, :year, :cvc, presence: true
  before_save :set_card_number

  def set_card_number
    self[:number] = "****#{self[:number].last(4)}"
  end
end
