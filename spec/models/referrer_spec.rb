# == Schema Information
#
# Table name: referrers
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)
#  group_code :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Referrer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
