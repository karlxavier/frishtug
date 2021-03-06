require 'rails_helper'

RSpec.describe "admin/units/new", type: :view do
  before(:each) do
    assign(:admin_unit, Unit.new())
  end

  it "renders new admin_unit form" do
    render

    assert_select "form[action=?][method=?]", units_path, "post" do
    end
  end
end
