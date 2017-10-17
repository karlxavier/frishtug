# == Schema Information
#
# Table name: menus
#
#  id               :integer          not null, primary key
#  name             :string
#  price            :decimal(8, 2)
#  unit_id          :integer
#  menu_category_id :integer
#  diet_category_id :integer
#  published_at     :datetime
#  published        :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  image            :string
#

require 'rails_helper'

RSpec.describe Menu, type: :model do
  it 'should have a valid factory' do
    expect(build(:menu)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:unit_id) }
    it { should validate_presence_of(:menu_category_id) }
    it 'should not be valid if price is below 0.01' do
      menu = build(:menu, price: 0.00)
      menu.valid?
      expect(menu.errors.full_messages).to include('Price should be atleast 0.01')
    end
  end

  describe 'ActiveModel associations' do
    it { should belong_to(:menu_category) }
    it { should belong_to(:diet_category) }
    it { should belong_to(:unit) }
    it { should have_and_belong_to_many(:add_ons) }
  end

  it 'should save with diet_category' do
    menu = build(:menu_with_diet_category)
    expect(menu).to be_valid
  end

  it 'should save without diet_category' do
    menu = build(:menu_without_diet_category)
    expect(menu).to be_valid
  end
end
