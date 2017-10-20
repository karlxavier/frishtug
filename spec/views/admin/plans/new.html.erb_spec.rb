require 'rails_helper'

RSpec.describe "admin/plans/new", type: :view do
  before(:each) do
    assign(:admin_plan, Plan.new())
  end

  it "renders new admin_plan form" do
    render

    assert_select "form[action=?][method=?]", plans_path, "post" do
    end
  end
end
