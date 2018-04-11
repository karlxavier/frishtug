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
  end
end