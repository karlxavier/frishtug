# == Schema Information
#
# Table name: schedules
#
#  id         :integer          not null, primary key
#  option     :integer
#  start_date :datetime
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Schedule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
