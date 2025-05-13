Rails.application.routes.draw do
  root "home#index"

  get "home/index"
  get "home/work_journal"
  get "home/order_fulfillment"

  # Dream Journal App
  resources :dreams, only: [:new, :create, :index, :show, :destroy]
  get "/dreams/search", to: "dreams#search", as: "search_dreams"
  
  # Aliases for UI clarity (optional, routes to same as `dreams#new`)
  get "/dream_journal", to: "dreams#index", as: "dream_journal"
  
  # Work Journal & Order Fulfillment (coming soon)
  get "/work_journal", to: "home#work_journal"
  get "/order_fulfillment", to: "home#order_fulfillment"
end
