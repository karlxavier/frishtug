# == Schema Information
#
# Table name: checkings
#
#  id             :integer          not null, primary key
#  bank_name      :string
#  account_number :string
#  routing_number :string
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  token          :string
#

require 'rails_helper'

RSpec.describe Checking, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
