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
#

class Checking < ApplicationRecord
  belongs_to :user
end
