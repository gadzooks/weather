Rails.application.routes.draw do
  root 'weather#index'
  get 'weather/index', as: :weather
  get 'test', to: 'weather#index', defaults: { test: 'true' }, as: :test
  get 'prod', to: 'weather#index', defaults: { test: 'false' }, as: :prod_test
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
