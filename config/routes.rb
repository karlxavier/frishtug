Rails.application.routes.draw do
  resources :user_registrations, only: %i[index create] do
    collection do
      get :schedule
      get :payment_method
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  devise_for :admins

  namespace :admin do
    resources :units, except: :show
    resources :menus, except: :show
    resources :dashboard, only: :index
    resources :menu_categories, except: %i[show]
    resources :plans
  end
end
