# == Schema Information
#
# Table name: notifications
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  body       :text
#  expiry     :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Notification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
