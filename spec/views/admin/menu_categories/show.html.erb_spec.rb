require 'rails_helper'

RSpec.describe "admin/menu_categories/show", type: :view do
  before(:each) do
    @admin_menu_category = assign(:admin_menu_category, MenuCategory.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
