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
