# == Schema Information
#
# Table name: contact_us_messages
#
#  id         :bigint(8)        not null, primary key
#  first_name :string
#  last_name  :string
#  email      :string
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ContactUsMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
