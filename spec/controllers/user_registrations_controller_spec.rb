require 'rails_helper'

RSpec.describe UserRegistrationsController, type: :controller do

  describe "GET #index" do
    context 'when user is not logged in' do
      before do
        get :index
      end

      it { is_expected.to render_template :index }
      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :application }
    end
  end

end
