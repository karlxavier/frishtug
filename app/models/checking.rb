# == Schema Information
#
# Table name: checkings
#
#  id             :integer          not null, primary key
#  bank_name      :string
#  account_number :string
#  routing_number :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  token          :string
#  stripe_id      :string
#

class Checking < ApplicationRecord
  belongs_to :user
  before_save :set_account_number
  validates :bank_name, :account_number, :routing_number, presence: true

  def set_account_number
    self[:account_number] = "****#{account_number.last(4)}"
  end
end
