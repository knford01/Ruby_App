Rails.application.routes.draw do
  root "home#index"

  get "home/index"

  # Dream Journal App
  resources :dreams, only: [:new, :create, :index, :show, :destroy]
  get "/dreams/search", to: "dreams#search", as: "search_dreams"
  get "/dream_journal", to: "dreams#index", as: "dream_journal"
  
  # Work Journal App
  resources :work_days, only: [:new, :create, :index, :show, :destroy] do
    resources :work_entries, only: [:new, :create, :destroy]
    collection do
      get :search
    end
  end
  get "/work_journal", to: "work_days#index", as: "work_journal"

  # Order Fulfillment App
  resources :orders, only: [:index, :show, :update] do
    collection do
      post :import
      get :shipped
      get :delivered
    end
    member do
      patch :mark_delivered
    end
  end
  get "/order_fulfillment", to: "orders#index", as: "order_fulfillment"
end
