# == Schema Information
#
# Table name: inactive_users
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class InactiveUser < ApplicationRecord
  enum status: %i[pending completed]
end
