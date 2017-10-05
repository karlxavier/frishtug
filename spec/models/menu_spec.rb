require 'rails_helper'

RSpec.describe Menu, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:unit_id) }
  it { should validate_presence_of(:menu_category_id) }
  it { should belong_to(:menu_category) }
  it { should belong_to(:diet_category) }
  it { should belong_to(:unit) }
end
