require 'rails_helper'

RSpec.describe "admin/allowed_zip_codes/new", type: :view do
  before(:each) do
    assign(:admin_allowed_zip_code, Admin::AllowedZipCode.new(
      :model=AllowedZipCode => "MyString"
    ))
  end

  it "renders new admin_allowed_zip_code form" do
    render

    assert_select "form[action=?][method=?]", admin_allowed_zip_codes_path, "post" do

      assert_select "input[name=?]", "admin_allowed_zip_code[model=AllowedZipCode]"
    end
  end
end
