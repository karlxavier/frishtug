# == Schema Information
#
# Table name: plans
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  price             :decimal(8, 2)
#  shipping          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  shipping_fee      :decimal(8, 2)
#  note              :text
#  shipping_note     :string
#  stripe_plan_id    :string
#  interval          :string
#  users_count       :integer          default(0)
#  for_type          :string
#  short_description :string(150)
#

require 'rails_helper'

RSpec.describe Plan, type: :model do
  it 'has a valid factory' do
    expect(build(:plan)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
  end

  describe 'ActiveModel associations' do
    it { should have_many(:users) }
  end
end 
