require 'rails_helper'

RSpec.describe MenuAddOn, type: :model do
  it 'has valid factory' do
    menu_category = create(:menu_category)
    unit = create(:unit)
    menu = create(:menu, unit_id: unit.id, menu_category_id: menu_category.id)
    add_on = create(:add_on, menu_category_id: menu_category.id)
    menu_add_on = build(:menu_add_on, menu_id: menu.id, add_on_id: add_on.id)
    expect(menu_add_on).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:menu_id) }
    it { should validate_presence_of(:add_on_id) }
  end

  describe 'ActiveModel associations' do
    it { should belong_to(:menu) }
    it { should belong_to(:add_on) }
  end
end
