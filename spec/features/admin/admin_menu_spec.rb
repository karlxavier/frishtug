require 'spec_helper'
require 'rails_helper'
RSpec.feature 'Your menu page' do
  scenario 'Admin creates a category' do
    admin_signs_in_and_proceed_to_your_menu
    expect(find('#title')).to have_content('Your Menu')
    admin_clicks_add_category_link
    admin_fills_in_the_form_and_submits
  end

  def admin_signs_in_and_proceed_to_your_menu
    login_as_admin
    click_link 'Your Menu'
  end

  def admin_clicks_add_category_link
    expect(find('.add-category-btn', text: '+ Add Category')).to be_visible
    find('.add-category-btn').click
    expect(find('.modal')).to be_visible
    expect(find('form#new-menu-category')).to be_visible
  end

  def admin_fills_in_the_form_and_submits
    fill_in 'Name', with: 'Bread - Rolls'
    click_button 'Save'
    expect(page).to have_content('Category save successfully.')
  end
end
