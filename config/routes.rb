require "sidekiq/web"

Rails.application.routes.draw do
  # Root route
  root to: "shows#index"

  # Third-party routes
  mount Sidekiq::Web => "/sidekiq"

  # Sessions
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Public-facing routes
  resources :shows, only: %i[index show] do
    resources :seats, only: [] do
      resource :reservation, only: %i[create destroy], controller: "shows/seat_reservations"
    end
  end

  resources :merch, only: %i[index show]

  resources :orders, only: %i[new create show index]
  namespace :orders do
    resources :shopping_cart_merch, only: %i[destroy update], controller: :shopping_cart_merch
    delete "/seat/:id/reservations", to: "seat_reservations#destroy", as: :seat_reservations
  end

  resource :shopping_cart, only: %i[show], controller: "shopping_cart" do
    resources :merch, only: %i[new create update destroy], controller: "shopping_cart/merch"
  end

  # Admin routes
  namespace :admin do
    resources :merch, except: %i[show] do
      resource :on_sale, only: %i[create], controller: "merch/on_sale"
    end

    namespace :merch do
      resources :categories, except: %i[show]
      resources :category_fields, only: %i[new]
    end

    resources :shows, except: %i[show]
    namespace :shows do
      resources :seating_charts, only: [] do
        resources :sections, only: %i[new]
      end
    end
    resources :artists
    resources :seating_charts do
      resources :sections, only: %i[new]
    end

    namespace :seating_charts do
      resources :sections, only: %i[new]
      resources :seats, only: %i[new]
    end
  end
end