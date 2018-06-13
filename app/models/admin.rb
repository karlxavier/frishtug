# == Schema Information
#
# Table name: admins
#
#  id                 :bigint(8)        not null, primary key
#  email              :string           default(""), not null
#  encrypted_password :string           default(""), not null
#  sign_in_count      :integer          default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string
#  last_sign_in_ip    :string
#  failed_attempts    :integer          default(0)
#  unlock_token       :string
#  locked_at          :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Admin < ApplicationRecord
  devise :database_authenticatable, :trackable, :timeoutable, :lockable
  validates :email, presence: true
  validates :email, uniqueness: true
end
