# == Schema Information
#
# Table name: users
#
#  id                      :bigint(8)        not null, primary key
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  first_name              :string
#  last_name               :string
#  plan_id                 :bigint(8)
#  stripe_token            :string
#  subscribe_at            :datetime
#  subscription_expires_at :datetime
#  stripe_customer_id      :string
#  stripe_subscription_id  :string
#  approved                :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a working factory' do
    expect(build(:user)).to be_valid
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe 'ActiveModel associations' do
    it { should have_many(:addresses) }
    it { should belong_to(:plan) }
    it { should have_one(:contact_number) }
  end
end
