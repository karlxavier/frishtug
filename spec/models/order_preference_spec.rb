# == Schema Information
#
# Table name: order_preferences
#
#  id         :integer          not null, primary key
#  copy_menu  :boolean
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe OrderPreference, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
