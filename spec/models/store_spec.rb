# == Schema Information
#
# Table name: stores
#
#  id         :integer          not null, primary key
#  _id        :integer
#  _code      :string
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Store, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
