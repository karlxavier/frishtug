require 'rails_helper'

RSpec.describe Inventory, type: :model do
  it 'should have a valid factory' do
    expect(build(:inventory)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:menu_id) }
  end

  describe 'ActiveModel associations' do
    it { should belong_to(:menu) }
    it { should have_many(:inventory_transactions)}
  end
end
