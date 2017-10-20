require 'rails_helper'

RSpec.describe "admin/plans/index", type: :view do
  before(:each) do
    assign(:plans, [
      Plan.create!(),
      Plan.create!()
    ])
  end

  it "renders a list of admin/plans" do
    render
  end
end
