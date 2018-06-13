# == Schema Information
#
# Table name: candidates
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)
#  referrer_id :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Candidate < ApplicationRecord
  include UserDelegator
  belongs_to :user
  belongs_to :referrer
end
