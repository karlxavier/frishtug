# == Schema Information
#
# Table name: blackout_dates
#
#  id          :bigint(8)        not null, primary key
#  month       :string
#  day         :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class BlackoutDate < ApplicationRecord
  class << self
    def pluck_dates
      pluck(:month, :day).map { |d| "#{d[0]} #{d[1] >= 10 ? d[1] : "0#{d[1]}"}" }
    end
  end
end
