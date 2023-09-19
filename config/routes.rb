require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount StripeEvent::Engine => '/webhooks'

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  namespace :admin do
    resources :shows, except: %i[show]

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

  resources :shows, only: %i[show index] do
    resources :seats, only: [] do
      resource :reservation, only: %i[ create destroy ], controller: "shows/seat_reservations"
    end
  end

  resources :orders, only: %i[ new create show index ]

  resource :shopping_cart, only: %i[ show ], controller: "shopping_cart"

  delete '/orders/seat/:id/reservations', to: 'orders/seat_reservations#destroy', as: :order_seat_reservations

  root to: "shows#index"
end
