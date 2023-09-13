require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  namespace :admin do
    resources :shows

    namespace :shows do
      resources :seating_charts do
        resources :sections, only: %i[new]
      end
    end

    resources :artists
    resources :seating_charts

    namespace :seating_charts do
      resources :sections, only: %i[new], controller: "sections"
      resources :seats, only: %i[new]
    end
  end

  resources :shows, only: %i[show] do
    resources :seats, only: [] do
      resource :reservation, only: %i[ create destroy ], controller: "shows/seat_reservations"
    end
  end

  root to: "shows#index"
end
