require 'rails_helper'

RSpec.describe "Admin::AllowedZipCodes", type: :request do
  describe "GET /admin_allowed_zip_codes" do
    it "works! (now write some real specs)" do
      get admin_allowed_zip_codes_path
      expect(response).to have_http_status(200)
    end
  end
end
