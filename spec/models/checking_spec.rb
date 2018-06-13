# == Schema Information
#
# Table name: checkings
#
#  id             :bigint(8)        not null, primary key
#  bank_name      :string
#  account_number :string
#  routing_number :string
#  user_id        :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  token          :string
#  stripe_id      :string
#

require 'rails_helper'

RSpec.describe Checking, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
