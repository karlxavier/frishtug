require 'rails_helper'

RSpec.describe "admin/plans/edit", type: :view do
  before(:each) do
    @admin_plan = assign(:admin_plan, Plan.create!())
  end

  it "renders the edit admin_plan form" do
    render

    assert_select "form[action=?][method=?]", admin_plan_path(@admin_plan), "post" do
    end
  end
end
