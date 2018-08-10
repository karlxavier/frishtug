namespace :user do
  resources :dashboard, only: :index
  resources :settings, only: :index
  resources :user_information, only: %i[index create]
  resources :change_password, only: %i[index create]
  resources :delivery_information, only: %i[index create]
  resources :payment_informations do
    put :update, on: :collection
  end
  resources :change_subscriptions, only: [:index, :create]
  resources :subscriptions, only: [:index, :create] do
    collection do
      post :cancel
      get :choose_plans
      get :subscribe
    end
  end
  resources :weekly_meals, except: :show do
    collection do
      get :category
      get :edit
    end
  end
  resources :temp_orders do
    collection do
      get :store
      get :remove
      get :persist
    end
  end
  resources :orders do
    collection do
      get :store
      get :remove
      get :persist
      get :cancel
      get :undo_cancel
      get :persist_template
    end
  end
  resources :set_default_payments, only: :create
  resources :scanovators, only: :index
  resources :complaints, only: :create
  resources :copy_meals, only: :create
  resources :duplicate_meals, only: :create
  resources :schedules, only: %i[index create]
  resources :bill_histories, only: :index
  resources :invitations, only: :create
  resources :set_active_addresses, only: :index
  resources :nutritional_data, only: :index
  resources :plans, only: :index
  resources :ledgers, path: "pending_charges", only: :index do
    collection do
      get :pay
    end
  end
  resources :set_credit, only: :index
  resources :refundable_credits, only: %i[index update]
  resources :candidates, only: :destroy
  resources :groups, only: :create do
    collection do
      post :join
    end
  end
  resources :create_new_months, only: %i[index create new] do
    collection do
      get :edit
    end
  end
end
