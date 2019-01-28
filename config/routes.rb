Rails.application.routes.draw do
  root 'weather#index'
  get 'weather/index', as: :weather
  get 'all', to: 'weather#index',  defaults: { locations: :all }
  get 'test', to: 'weather#index', defaults: { test: 'true' }, as: :test
  get 'prod', to: 'weather#index', defaults: { test: 'false' }, as: :prod_test
  get 'deep-ping', to: 'ping#deep_ping'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Blazer::Engine, at: "blazer" # https://github.com/ankane/blazer
end
