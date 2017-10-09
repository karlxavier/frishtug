require 'spec_helper'
require 'rails_helper'

RSpec.feature 'Admin dashboard' do
  scenario 'Admin can navigate to admins/sign_in page' do
    visit admin_session_path
    expect(page).to have_content('Log in')
  end

  scenario 'Admin signs in' do
    login_as_admin
    expect(page).to have_content('Dashboard')
  end
end
