namespace :api do
  namespace :v1 do
    resources :items, only: [:index, :show]
    resources :menu_categories, only: :index
    resources :plans, only: :index
    resources :allowed_zip_codes, only: :index
  end
end