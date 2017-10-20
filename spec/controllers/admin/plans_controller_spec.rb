describe Admin::PlansController, type: :controller do
  let(:admin) { create(:admin) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:admin]
  end

  describe 'Get #index' do
    context 'when admin is logged in' do
      before do
        sign_in admin
        get :index
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_with_layout :admin_dashboard }
      it { is_expected.to render_template :index }
    end

    context 'when admin is logged out' do
      before do
        get :index
      end

      it { is_expected.to redirect_to new_admin_session_path }
    end
  end

  describe 'Post #create' do
    before do
      sign_in admin
    end

    context 'with valid params' do
      before do
        post :create, format: :js, params: { plan: build(:plan).attributes }
      end

      it { is_expected.to set_flash }
      it { is_expected.to render_template :create }
      it 'is expected to render create.js' do
        expect(response.headers["Content-Type"]).to eq "text/javascript; charset=utf-8"
      end
    end

    context 'with invalid params' do
      before do
        post :create, format: :js, params: { plan: build(:plan, name: nil).attributes }
      end

      it { is_expected.to set_flash }
      it { is_expected.to render_template :create }
      it 'is expected to render create.js' do
        expect(response.headers["Content-Type"]).to eq "text/javascript; charset=utf-8"
      end
    end
  end

  describe 'Put #update' do
    before do
      sign_in admin
    end

    context 'with valid params' do
      before do
        plan = create(:plan)
        put :update, format: :js, params: { id: plan.to_param, plan: build(:plan).attributes.except(:id) }
      end

      it { is_expected.to set_flash }
      it { is_expected.to render_template :update }
      it 'is expected to render update.js' do
        expect(response.headers["Content-Type"]).to eq "text/javascript; charset=utf-8"
      end
    end

    context 'with invalid params' do
      before do
        plan = create(:plan)
        put :update, format: :js, params: { id: plan.to_param, plan: build(:plan, name: nil).attributes.except(:id) }
      end

      it { is_expected.to set_flash }
      it { is_expected.to render_template :update }
      it 'is expected to render update.js' do
        expect(response.headers["Content-Type"]).to eq "text/javascript; charset=utf-8"
      end
    end
  end
end
