# == Schema Information
#
# Table name: orders
#
#  id              :bigint(8)        not null, primary key
#  user_id         :bigint(8)
#  placed_on       :datetime
#  eta             :string
#  delivered_at    :datetime
#  status          :integer
#  remarks         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  order_date      :datetime
#  series_number   :integer
#  sku             :string
#  delivery_status :integer
#  payment_details :string
#  route_started   :string
#  payment_status  :integer
#  total_price     :decimal(8, 2)    default(0.0)
#  is_rollover     :boolean          default(FALSE)
#  charge_id       :string
#

require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'should have a valid factory' do
    expect(build(:order)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:placed_on) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'ActiveModel associations' do
    it { should belong_to(:user) }
  end

  describe 'ActiveModel enum' do
    it { should define_enum_for(:status) }
  end
end
