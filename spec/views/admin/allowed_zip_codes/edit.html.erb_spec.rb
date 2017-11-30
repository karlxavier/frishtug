require 'rails_helper'

RSpec.describe "admin/allowed_zip_codes/edit", type: :view do
  before(:each) do
    @admin_allowed_zip_code = assign(:admin_allowed_zip_code, Admin::AllowedZipCode.create!(
      :model=AllowedZipCode => "MyString"
    ))
  end

  it "renders the edit admin_allowed_zip_code form" do
    render

    assert_select "form[action=?][method=?]", admin_allowed_zip_code_path(@admin_allowed_zip_code), "post" do

      assert_select "input[name=?]", "admin_allowed_zip_code[model=AllowedZipCode]"
    end
  end
end
