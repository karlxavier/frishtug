require 'rails_helper'

RSpec.describe AddOn, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:menu_category_id) }
  it { should belong_to(:menu_category) }
end
