require 'rails_helper'

RSpec.describe "admin/menus/edit", type: :view do
  before(:each) do
    @admin_menu = assign(:admin_menu, Menu.create!())
  end

  it "renders the edit admin_menu form" do
    render

    assert_select "form[action=?][method=?]", admin_menu_path(@admin_menu), "post" do
    end
  end
end
