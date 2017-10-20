feature 'Admin plan page', type: :feature do
  scenario 'has an index page' do
    login_as_admin
    visit '/admin/plans'
    expect(find('h1', text: 'Plans')).to be_visible
  end
end