Rails.application.routes.draw do
  root 'weather#index'
  get 'weather/index', as: :weather
  get 'regional', to: 'weather#by_region',  defaults: { locations: :all }
  get 'all', to: 'weather#index',  defaults: { locations: :all }
  get 'test', to: 'weather#index', defaults: { test: 'true' }, as: :test
  get 'prod', to: 'weather#index', defaults: { test: 'false' }, as: :prod_test
  get 'deep-ping', to: 'ping#deep_ping'

  resource :users, only: [:create]
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Blazer::Engine, at: "blazer" # https://github.com/ankane/blazer
end
