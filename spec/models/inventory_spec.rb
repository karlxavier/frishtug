# == Schema Information
#
# Table name: inventories
#
#  id           :bigint(8)        not null, primary key
#  menu_id      :bigint(8)
#  location     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  inventory_id :string
#  quantity     :integer
#

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
