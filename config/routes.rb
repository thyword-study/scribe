Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Home
  root to: "pages#home"

  # Articles
  resources :articles, param: :slug, only: [ :index, :show ]

  # Bible (Reading)
  resources :translations, param: :code, only: [ :show ], constraints: { code: /[a-z]+/ } do
    resources :books, param: :slug, only: [ :index, :show ] do
      resources :chapters, param: :number, only: [ :index, :show ]
    end
  end

  # Bible (Commentary)
  namespace :commentary do
    resources :books, param: :slug, only: [ :index, :show ] do
      resources :chapters, param: :number, only: [ :index, :show ] do
        resources :sections, only: [ :show ]
      end
    end
  end

  # Miscellanous
  get "search", to: "search#index"
end
