# == Schema Information
#
# Table name: taxes
#
#  id         :bigint(8)        not null, primary key
#  rate       :float
#  store_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Tax, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
