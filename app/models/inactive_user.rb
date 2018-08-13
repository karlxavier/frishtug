# frozen_string_literal: true

# == Schema Information
#
# Table name: inactive_users
#
#  id         :bigint(8)        not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class InactiveUser < ApplicationRecord
  enum status: %i[pending completed]
  validate :does_user_exists?
  validates :first_name, :last_name, :email, presence: true

  private

  def does_user_exists?
    if User.where(email: email).any?
      errors.add(:base, "User exists!")
      false
    end
  end
end
