Rails.application.routes.draw do
  root 'weather#index'
  get 'weather/index'
  get 'prod', to: 'weather#index', defaults: { prod: 'true' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
