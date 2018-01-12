# == Schema Information
#
# Table name: admins
#
#  id                 :integer          not null, primary key
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

FactoryBot.define do
  factory :admin do
    email 'admin@frishtug.com'
    password 'frishtug2017!'
  end
end
