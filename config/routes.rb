Rails.application.routes.draw do
  root to: 'exchangers#index'

  resources :exchangers, only: :index
  resources :currencies, only: :index
end
