# == Schema Information
#
# Table name: contact_numbers
#
#  id           :integer          not null, primary key
#  phone_number :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe ContactNumber, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
