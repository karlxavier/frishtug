# == Schema Information
#
# Table name: contact_numbers
#
#  id           :bigint(8)        not null, primary key
#  phone_number :string
#  user_id      :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe ContactNumber, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
