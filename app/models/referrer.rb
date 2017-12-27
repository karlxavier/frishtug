# == Schema Information
#
# Table name: referrers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  group_code :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Referrer < ApplicationRecord
  include UserDelegator
  belongs_to :user
  has_many :candidates, dependent: :destroy
  validates :group_code, presence: true
end
