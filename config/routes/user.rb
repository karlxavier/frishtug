namespace :user do
  resources :dashboard, only: :index
  resources :settings, only: :index
  resources :user_information, only: %i[index create]
  resources :change_password, only: %i[index create]
  resources :delivery_information, only: %i[index create]
  resources :payment_informations do
    put :update, on: :collection
  end
  resources :subscriptions, only: :index do
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
    end
  end
  resources :set_default_payments, only: :create
  resources :scanovators, only: :index
  resources :complaints, only: :create
  resources :copy_meals, only: :create
  resources :duplicate_meals, only: :create
end
