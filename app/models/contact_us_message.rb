# frozen_string_literal: true

# == Schema Information
#
# Table name: contact_us_messages
#
#  id         :bigint(8)        not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactUsMessage < ApplicationRecord
  default_scope { order(created_at: :desc) }
  validates :email, :first_name, :last_name, presence: true

  def full_name
    [first_name, last_name].join(' ')
  end
end
