# == Schema Information
#
# Table name: nutritional_data
#
#  id         :bigint(8)        not null, primary key
#  menu_id    :bigint(8)
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe NutritionalData, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
