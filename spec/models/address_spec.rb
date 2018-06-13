# == Schema Information
#
# Table name: addresses
#
#  id               :bigint(8)        not null, primary key
#  line1            :string
#  line2            :string
#  front_door       :string
#  city             :string
#  state            :string
#  zip_code         :string
#  addressable_type :string
#  addressable_id   :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  location_at      :integer
#  status           :integer
#  latitude         :float
#  longitude        :float
#

RSpec.describe Address, type: :model do
  describe 'ActiveModel validations' do
    it { should validate_presence_of(:line1) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:state) }
  end

  describe 'ActiveModel associations' do
    it { should belong_to(:addressable) }
  end
end
