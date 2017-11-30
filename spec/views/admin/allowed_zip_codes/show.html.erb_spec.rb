require 'rails_helper'

RSpec.describe "admin/allowed_zip_codes/show", type: :view do
  before(:each) do
    @admin_allowed_zip_code = assign(:admin_allowed_zip_code, Admin::AllowedZipCode.create!(
      :model=AllowedZipCode => "Model=Allowed Zip Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Model=Allowed Zip Code/)
  end
end
