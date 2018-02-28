# == Schema Information
#
# Table name: blackout_dates
#
#  id          :integer          not null, primary key
#  month       :string
#  day         :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BlackoutDate < ApplicationRecord
end
