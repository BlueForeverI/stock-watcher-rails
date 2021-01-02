Rails.application.routes.draw do
  scope(:path => '/api') do
    post "/login", to: "auth#login"
    
    get "/users/:id/stocks", to: "users#stocks"
    post "/users/:user_id/stocks", to: "users#add_stock"
    delete "/users/:user_id/stocks/:stock_id", to: "users#remove_stock"
    get "/users/:id/watchlist", to: "users#watchlist"

    get "/stocks/trending", to: "stocks#trending"

    resources :stocks
    resources :users
  end
end
