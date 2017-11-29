Rails.application.routes.draw do
  resources :user_registrations, only: %i[index create] do
    collection do
      get :schedule
      get :selected_date
      get :days
      get :is_past_noon
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  devise_for :admins

  draw :admin
  draw :user
end
