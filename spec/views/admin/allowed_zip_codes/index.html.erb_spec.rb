require 'rails_helper'

RSpec.describe "admin/allowed_zip_codes/index", type: :view do
  before(:each) do
    assign(:admin_allowed_zip_codes, [
      Admin::AllowedZipCode.create!(
        :model=AllowedZipCode => "Model=Allowed Zip Code"
      ),
      Admin::AllowedZipCode.create!(
        :model=AllowedZipCode => "Model=Allowed Zip Code"
      )
    ])
  end

  it "renders a list of admin/allowed_zip_codes" do
    render
    assert_select "tr>td", :text => "Model=Allowed Zip Code".to_s, :count => 2
  end
end
