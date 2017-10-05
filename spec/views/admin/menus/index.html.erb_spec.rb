require 'rails_helper'

RSpec.describe "admin/menus/index", type: :view do
  before(:each) do
    assign(:menus, [
      Menu.create!(),
      Menu.create!()
    ])
  end

  it "renders a list of admin/menus" do
    render
  end
end
