require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'ActiveModel validations' do
    it { should validate_presence_of(:line1) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:state) }
  end
  
  describe 'ActiveModel associations' do
    it { should belong_to(:addressable) }
  end
end
