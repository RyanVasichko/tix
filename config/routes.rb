Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :admin do
    resources :seating_charts

    namespace :seating_charts do 
      resources :sections, only: %i[new], controller: "sections"
      resources :seats, only: %i[new]
    end
  end

  root to: "admin/seating_charts#new"
end
