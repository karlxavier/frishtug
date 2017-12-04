Rails.application.routes.draw do
  resources :user_registrations, only: %i[index create] do
    collection do
      get :schedule
    end
  end
  resources :calendars, only: :index
  resources :selected_dates, only: :index
  resources :past_noons, only: :index

  require 'sidekiq/web'

  devise_for :users
  devise_for :admins

  draw :admin
  draw :user
end
