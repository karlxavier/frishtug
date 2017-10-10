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
