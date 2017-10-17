# == Schema Information
#
# Table name: menu_add_ons
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  add_on_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

RSpec.describe MenuAddOn, type: :model do
  describe 'ActiveModel validations' do
    it { should validate_presence_of(:menu_id) }
    it { should validate_presence_of(:add_on_id) }
  end

  describe 'ActiveModel associations' do
    it { should belong_to(:menu) }
    it { should belong_to(:add_on) }
  end
end
