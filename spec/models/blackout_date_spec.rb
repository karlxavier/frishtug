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

require 'rails_helper'

RSpec.describe BlackoutDate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
