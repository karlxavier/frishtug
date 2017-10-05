require 'rails_helper'

RSpec.describe "admin/units/index", type: :view do
  before(:each) do
    assign(:units, [
      Unit.create!(),
      Unit.create!()
    ])
  end

  it "renders a list of admin/units" do
    render
  end
end
