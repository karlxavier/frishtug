# == Schema Information
#
# Table name: assets
#
#  id         :bigint(8)        not null, primary key
#  image      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  file_name  :string
#

require 'rails_helper'

RSpec.describe Asset, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
