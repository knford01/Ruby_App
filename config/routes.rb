Rails.application.routes.draw do
  root "home#index"

  get "home/index"
  get "home/work_journal"
  get "home/order_fulfillment"

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

  # Order Fulfillment App (coming soon)
  get "/order_fulfillment", to: "home#order_fulfillment"
end
