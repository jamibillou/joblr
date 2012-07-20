require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users do
    resources :authentifications, only: [:index, :destroy]
    resources :profiles
  end

  match 'home', to: 'pages#home'

  root to: 'users#show', constraints: SignedIn.new(true)
  root to: 'pages#home', constraints: SignedIn.new(false)
end