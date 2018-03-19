namespace :api do
  namespace :v1 do
    resources :items, only: :index
    resources :menu_categories, only: :index
  end
end