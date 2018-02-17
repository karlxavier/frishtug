# == Schema Information
#
# Table name: menu_categories
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  display_order :integer
#  part_of_plan  :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe MenuCategory, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:menus) }
  it { should have_many(:add_ons) }
end
