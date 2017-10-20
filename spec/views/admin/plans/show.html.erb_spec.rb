require 'rails_helper'

RSpec.describe "admin/plans/show", type: :view do
  before(:each) do
    @admin_plan = assign(:admin_plan, Plan.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
