# == Schema Information
#
# Table name: add_ons_menus
#
#  id         :integer          not null, primary key
#  add_on_id  :integer
#  menu_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AddOnsMenu, type: :model do
  it { should belong_to(:menu) }
  it { should belong_to(:add_on) }
end
