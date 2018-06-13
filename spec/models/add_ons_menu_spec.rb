# == Schema Information
#
# Table name: add_ons_menus
#
#  id         :bigint(8)        not null, primary key
#  add_on_id  :bigint(8)
#  menu_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AddOnsMenu, type: :model do
  it { should belong_to(:menu) }
  it { should belong_to(:add_on) }
end
