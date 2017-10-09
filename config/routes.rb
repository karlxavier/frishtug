Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  namespace :admin do
    resources :units
    resources :menus
    resources :dashboard, only: :index
    resources :menu_categories, except: %i[index show]
  end
end
