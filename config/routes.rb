Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  namespace :admin do
    root to: 'admin#index'

    resources :artists
    resources :seating_charts

    namespace :seating_charts do 
      resources :sections, only: %i[new], controller: "sections"
      resources :seats, only: %i[new]
    end
  end

  root to: "admin/admin#index"
end
