# == Schema Information
#
# Table name: assets_stores
#
#  id         :integer          not null, primary key
#  store_id   :integer
#  asset_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AssetsStore, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
