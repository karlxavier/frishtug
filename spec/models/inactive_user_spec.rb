# == Schema Information
#
# Table name: inactive_users
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe InactiveUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end