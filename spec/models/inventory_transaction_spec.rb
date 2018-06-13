# == Schema Information
#
# Table name: inventory_transactions
#
#  id               :bigint(8)        not null, primary key
#  inventory_id     :bigint(8)
#  quantity_sold    :integer
#  transaction_date :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  quantity_on_hand :integer
#

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
