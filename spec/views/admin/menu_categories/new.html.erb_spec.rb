require 'rails_helper'

RSpec.describe "admin/menu_categories/new", type: :view do
  before(:each) do
    assign(:admin_menu_category, MenuCategory.new())
  end

  it "renders new admin_menu_category form" do
    render

    assert_select "form[action=?][method=?]", menu_categories_path, "post" do
    end
  end
end
