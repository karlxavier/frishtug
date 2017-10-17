require 'rails_helper'

RSpec.describe AddOnsMenu, type: :model do
  it { should belong_to(:menu) }
  it { should belong_to(:add_on) }
end
