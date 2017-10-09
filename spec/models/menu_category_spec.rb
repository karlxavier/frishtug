require 'rails_helper'

RSpec.describe MenuCategory, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:menus) }
  it { should have_many(:add_ons) }
end
