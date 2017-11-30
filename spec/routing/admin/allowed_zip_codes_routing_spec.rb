require "rails_helper"

RSpec.describe Admin::AllowedZipCodesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/allowed_zip_codes").to route_to("admin/allowed_zip_codes#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/allowed_zip_codes/new").to route_to("admin/allowed_zip_codes#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/allowed_zip_codes/1").to route_to("admin/allowed_zip_codes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/allowed_zip_codes/1/edit").to route_to("admin/allowed_zip_codes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/allowed_zip_codes").to route_to("admin/allowed_zip_codes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/allowed_zip_codes/1").to route_to("admin/allowed_zip_codes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/allowed_zip_codes/1").to route_to("admin/allowed_zip_codes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/allowed_zip_codes/1").to route_to("admin/allowed_zip_codes#destroy", :id => "1")
    end

  end
end
