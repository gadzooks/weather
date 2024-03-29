Rails.application.routes.draw do
  devise_for :users

  get "api/v1/weather", to: "weather#weather_json", defaults: { format: :json, client_type: Weather::VC_CLIENT, test: "true", locations: :all }

  root "weather#index"
  get "weather/index", as: :weather
  get "regional", to: "weather#by_region",  defaults: { locations: :all }
  get "vc", to: "weather#vc",  defaults: { locations: :all }, as: :vc
  get "all", to: "weather#index",  defaults: { locations: :all }
  get "test", to: "weather#index", defaults: { test: "true" }, as: :test
  get "prod", to: "weather#index", defaults: { test: "false" }, as: :prod_test
  get "deep-ping", to: "ping#deep_ping"
  get "about", to: "ping#about"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Blazer::Engine, at: "blazer" # https://github.com/ankane/blazer

end
