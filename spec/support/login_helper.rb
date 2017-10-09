module LoginHelper
  def login_as_admin
    visit admin_session_path
    login_as create(:admin)
  end

  def login_as(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
end
