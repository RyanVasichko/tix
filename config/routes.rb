Rails.application.routes.draw do
  # Root route
  root to: "shows#index"

  mount GoodJob::Engine => 'good_job'

  # Sessions
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

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
    resources :seats, only: [] do
      resource :reservation, only: %i[destroy], controller: "shopping_cart/seat_reservations"
    end
  end

  # Admin routes
  namespace :admin do
    get "/", to: "admin#index"
    resources :customer_questions, except: :show do
      resource :activation, only: :create, controller: "customer_questions/activation"
    end

    resources :merch, except: %i[show] do
      resource :on_sale, only: %i[create], controller: "merch/on_sale"
    end

    namespace :merch do
      resources :categories, except: %i[show]
      resources :category_fields, only: %i[new]
    end

    resources :shows, except: %i[show]
    namespace :shows do
      resource :upsale_fields, only: %i[new]
      resources :artists, only: %i[new create]

      resources :seating_charts, only: [] do
        resources :sections_fields, only: %i[index]
      end

      resources :venues, only: [] do
        resources :seating_chart_fields, only: %i[index]
      end
    end

    resources :artists

    resources :seating_charts do
      resources :sections, only: %i[new]
    end

    namespace :seating_charts do
      resources :sections, only: %i[new]
      resources :seats, only: %i[new]

      resources :venues, only: [] do
        resource :ticket_type_options, only: %i[show]
      end
    end

    resources :venues, except: %i[show]

    resources :ticket_types, except: %i[show]
  end

  # Hack so that sourcemaps work with Sprockets
  if Rails.env.development?
    redirector = lambda { |params, _req|
      ApplicationController.helpers.asset_path(params[:name].split('-').first + '.map')
    }
    constraint = ->(request) { request.path.ends_with?('.map') }
    get 'assets/*name', to: redirect(redirector), constraints: constraint
  end
end