require 'rails_helper'

RSpec.describe "admin/menu_categories/index", type: :view do
  before(:each) do
    assign(:menu_categories, [
      MenuCategory.create!(),
      MenuCategory.create!()
    ])
  end

  it "renders a list of admin/menu_categories" do
    render
  end
end
