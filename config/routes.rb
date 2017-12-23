Rails.application.routes.draw do
  resources :user_registrations, only: %i[index create] do
    collection do
      get :schedule
    end
  end
  resources :calendars, only: :index
  resources :selected_dates, only: :index
  resources :past_noons, only: :index
  resources :pages, only: :show, path: '/', as: :page, format: :false
  root to: 'pages#show', id: 'home'

  require 'sidekiq/web'

  devise_for :users
  devise_for :admins

  draw :admin
  draw :user
end
