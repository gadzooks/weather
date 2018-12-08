Rails.application.routes.draw do
  root 'weather#index'
  get 'weather/index'
  get 'test', to: 'weather#index', defaults: { prod: 'false' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
