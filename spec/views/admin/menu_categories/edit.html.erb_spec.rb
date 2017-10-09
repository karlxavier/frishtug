require 'rails_helper'

RSpec.describe "admin/menu_categories/edit", type: :view do
  before(:each) do
    @admin_menu_category = assign(:admin_menu_category, MenuCategory.create!())
  end

  it "renders the edit admin_menu_category form" do
    render

    assert_select "form[action=?][method=?]", admin_menu_category_path(@admin_menu_category), "post" do
    end
  end
end
