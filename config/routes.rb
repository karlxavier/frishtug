Rails.application.routes.draw do
  resources :user_registrations, only: %i[index create] do
    collection do
      get :schedule
    end
  end
  get '/verify_users', to: 'verify_users#verify'
  resources :calendars, only: :index
  resources :selected_dates, only: :index
  resources :past_noons, only: :index
  resources :inventories, only: :index
  resources :pages, only: :show, path: '/', as: :page, format: :false
  resources :contact_us, only: :create
  root to: 'pages#show', id: 'home'

  require 'sidekiq/web'

  devise_for :users
  devise_for :admins

  draw :admin
  draw :user
end
