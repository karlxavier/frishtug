namespace :admin do
  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end
  resources :units, except: :show
  resources :menus, except: :show
  resources :dashboard, only: :index
  resources :menu_categories, except: :show
  resources :plans
  resources :allowed_zip_codes, except: :show
  resources :import_menus, only: :index do
    post :import, on: :collection
  end
  resources :shoppings_lists
  resources :configs
  resources :inventory, only: :index
  resources :calendars, only: :index
  resources :scanovators, only: :create
  resources :assets, only: %i[index create destroy]
  resources :clients, only: %i[index show]
  resources :orders, only: %i[show edit update]
  resources :display_orders, only: :create
  resources :inactive_users, only: :index
  resources :blackout_dates
  resources :email_templates, only: [:index, :create]
  resources :refresh_orders, only: :index
  resources :search_results, only: :index
  resources :add_ons, only: :index
end
