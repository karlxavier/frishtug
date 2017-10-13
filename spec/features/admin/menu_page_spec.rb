require 'spec_helper'
require 'rails_helper'

feature 'Admin menu page', type: :feature do
  before :each do
    create_list(:menu_category, 3)
  end

  scenario 'if user is not signed in' do
    visit '/admin/menus'
    expect(page).to have_current_path(new_admin_session_path, only_path: true)
  end

  scenario 'has category navs' do
    expected_categories = MenuCategory.all.map(&:name).map { |m| "#{m}(0)" }
    admin_signs_in_and_proceed_to_your_menu
    actual_categories = find('ul#categories-nav').all('li a.nav-link').map(&:text)
    expect(actual_categories).to match_array(expected_categories)
    expect(actual_categories.count).to eq(expected_categories.count)
  end

  scenario 'creates a menu', js: true do
    create_list(:unit, 4)
    create(:unit, name: 'peace')
    admin_signs_in_and_proceed_to_your_menu
    admin_clicks_add_menu_item
    admin_fills_in_menu_form_fields
    admin_published_the_menu
  end

  scenario 'creates a category without add-ons' do
    admin_signs_in_and_proceed_to_your_menu
    expect(find('#title')).to have_content('Your Menu')
    admin_clicks_add_category_link
    admin_fills_the_category_name
    admin_saves_the_form
  end

  scenario 'creates a category with 3 add-ons', js: true do
    admin_signs_in_and_proceed_to_your_menu
    admin_clicks_add_category_link
    admin_fills_the_category_name
    admin_adds_and_fills_3_add_ons
    admin_saves_the_form
  end

  def admin_clicks_add_menu_item
    find('.add-menu-item').click
    expect(find('form#new-menu-item')).to be_visible
  end

  def admin_fills_in_menu_form_fields
    find('#menu_name').set('Tuna Bread')
    find('#menu_price').set('2.00')
    select 'peace', from: 'menu_unit_selection'
    file_path = Rails.root + 'spec/fixtures/test_file.jpg'
    page.execute_script("$('#menu_image').removeClass('d-none')")
    attach_file 'Browse', file_path
  end

  def admin_published_the_menu
    click_button 'Publish'
    expect(page).to have_content('Menu successfully publish.')
  end

  def admin_signs_in_and_proceed_to_your_menu
    login_as_admin
    visit admin_menus_path
  end

  def admin_clicks_add_category_link
    expect(find('.add-category-btn', text: '+ Add Category')).to be_visible
    find('.add-category-btn').click
    expect(find('#add-category-modal')).to be_visible
    expect(find('form#new-menu-category')).to be_visible
  end

  def admin_adds_and_fills_3_add_ons
    click_link '+ Add Add-ons'
    click_link '+ Add Add-ons'
    add_on_id = 'input#menu_category_addons_name'
    expect(find(add_on_id)).to be_visible
    expect(find("#{add_on_id}_1")).to be_visible
    expect(find("#{add_on_id}_2")).to be_visible

    find(add_on_id).set('Toasted')
    find("#{add_on_id}_1").set('Butter')
    find("#{add_on_id}_2").set('Cream Cheese')
  end

  def admin_fills_the_category_name
    fill_in 'menu_category[name]', with: 'Bread - Rolls'
  end

  def admin_saves_the_form
    click_button 'Save'
    expect(page).to have_content('Category save successfully.')
  end
end
