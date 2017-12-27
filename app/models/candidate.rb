# == Schema Information
#
# Table name: candidates
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  referrer_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Candidate < ApplicationRecord
  include UserDelegator
  belongs_to :user
  belongs_to :referrer
end
