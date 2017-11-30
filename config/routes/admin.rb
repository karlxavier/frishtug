namespace :admin do
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
  resources :config
end