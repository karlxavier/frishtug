require 'rails_helper'

RSpec.describe AddOn, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:menu_category_id)}
end
