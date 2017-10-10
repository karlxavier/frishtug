require 'rails_helper'

RSpec.describe InventoryTransaction, type: :model do
  it 'should have a valid factory' do
    expect(build(:inventory_transaction)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:inventory_id) }
    it { should validate_presence_of(:quantity_sold) }
    it { should validate_presence_of(:transaction_date) }
  end

  describe 'ActiveModel associations' do
    it { should belong_to(:inventory) }
  end
end
