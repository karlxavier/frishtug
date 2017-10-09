require 'rails_helper'

RSpec.describe Menu, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:unit_id) }
  it { should validate_presence_of(:menu_category_id) }
  it { should belong_to(:menu_category) }
  it { should belong_to(:diet_category) }
  it { should belong_to(:unit) }

  it 'should not be valid if price is below 0.01' do
    menu_category = create(:menu_category)
    menu = build(:menu, price: 0.00, menu_category_id: menu_category.id)
    menu.valid?
    expect(menu.errors.full_messages).to include('Price should be atleast 0.01')
  end

  it 'should save with diet_category_id' do
    menu_category = create(:menu_category)
    unit = create(:unit)
    diet_category = create(:diet_category)
    menu = build(:menu, menu_category_id: menu_category.id, unit_id: unit.id, diet_category_id: diet_category.id)
    expect(menu).to be_valid
  end

  it 'should save without diet_category_id' do
    menu_category = create(:menu_category)
    unit = create(:unit)
    menu = build(:menu, menu_category_id: menu_category.id, unit_id: unit.id)
    expect(menu).to be_valid
  end
end
