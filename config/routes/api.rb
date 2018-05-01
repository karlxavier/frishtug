namespace :api do
  namespace :v1 do
    resources :items, only: [:index, :show]
    resources :menu_categories, only: :index
    resources :plans, only: :index
    resources :allowed_zip_codes, only: :index
    resources :verify_users, only: :index
    resources :is_past, only: :index
    resources :calendar, only: :index
    resources :inactive_users, only: :create
    resources :earliest_dates, only: :index
    resources :selected_dates, only: :index
    resources :check_codes, only: :index
    resources :user_registrations, only: :create
    resources :taxs, only: :index
    resources :address, only: :index
    resources :server_time, only: :index
    resources :bill_histories, only: :index
    resources :order_status, only: :index
    resources :user_informations, only: :index
    resources :suggestion_complaints, only: :create
    resources :nutritional_data, onyl: %i[index show]

    namespace :users do
      resources :authenticate, only: :create
      resources :order_complaints, only: :create
      resources :current_order, only: :index
      resources :orders, only: %i[index show create update] do
        member do
          get :cancel
          get :undo_cancel
        end
      end
      resources :delivery_information, only: %i[index create update show]
      resources :payment_information, only: %i[index create update show]
      resources :subscriptions, only: :index do
        collection do
          put :cancel
          put :subscribe
        end
      end
      resources :schedules, only: %i[index create]
    end
  end
end