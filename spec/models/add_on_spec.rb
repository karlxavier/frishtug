# == Schema Information
#
# Table name: add_ons
#
#  id               :bigint(8)        not null, primary key
#  name             :string
#  menu_category_id :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  menu_id          :bigint(8)
#

RSpec.describe AddOn, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:menu_category_id) }
  it { should belong_to(:menu_category) }
  it { should have_and_belong_to_many(:menus) }
end
