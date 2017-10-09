require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a working factory' do
    expect(build(:user)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe 'ActiveModel associations' do
    it { should have_many(:address) }
    it { should belong_to(:plan) }
  end
end
