# == Schema Information
#
# Table name: allowed_zip_codes
#
#  id         :bigint(8)        not null, primary key
#  zip        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  store_id   :bigint(8)
#

require 'rails_helper'

RSpec.describe AllowedZipCode, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
