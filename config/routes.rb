Rails.application.routes.draw do
  # Root route
  root to: "shows#index"

  get "up" => "rails/health#show", as: :rails_health_check

  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Sessions
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Public-facing routes
  resources :shows, only: %i[index]
  namespace :shows do
    resources :general_admission, param: :show_id, only: [] do
      scope module: :general_admission do
        # TODO: Make this ticket_selections
        resource :ticket_selections, only: %i[new create]
      end
    end

    resources :reserved_seating, param: :show_id, only: %i[show] do
      scope module: :reserved_seating do
        resources :seat_holds, only: %i[create destroy index]
        resources :seats, only: [] do
          resource :ticket_selections, only: %i[create destroy]
        end
      end
    end
  end

  resources :merch, only: %i[index show] do
    scope module: :merch do
      resources :shopping_cart_selections, only: %i[new create]
    end
  end

  resources :orders, only: %i[new create show index]

  resource :shopping_carts, only: %i[show] do
    scope module: :shopping_carts do
      resources :merch_selections, only: %i[destroy update]

      namespace :ticket_selections do
        resources :general_admission, only: %i[destroy update]
      end
    end
  end

  # Admin routes
  namespace :admin do
    get "/", to: "admin#index"
    resources :customer_questions, except: :show do
      resource :activation, only: :create, controller: "customer_questions/activation"
    end

    resources :customers
    resources :admins
    resources :roles

    resources :orders, only: %i[index show]

    put "/merch/sort_order", to: "merch/sort_order#update"
    resources :merch, except: %i[show] do
      resource :on_sale, only: %i[create], controller: "merch/on_sale"
    end

    namespace :merch do
      resources :categories, except: %i[show]
      resources :shipping_rates, except: %i[show]
      resources :category_fields, only: %i[new]
    end

    resources :shows, except: %i[show]

    namespace :shows do
      resource :upsale_fields, only: %i[new]

      resources :seating_charts, only: [] do
        resources :reserved_seating_show_sections_fields, only: %i[index]
      end

      resources :general_admission_show_section_fields, only: %i[new]

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
end
