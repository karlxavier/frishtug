# == Schema Information
#
# Table name: assets_stores
#
#  id         :bigint(8)        not null, primary key
#  store_id   :bigint(8)
#  asset_id   :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AssetsStore, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
