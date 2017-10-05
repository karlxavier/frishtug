Rails.application.routes.draw do
  devise_for :admins

  namespace :admin do
    resources :units
    resources :menus
  end
end
