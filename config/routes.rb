require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :authentifications, only: [:index, :destroy]
  resources :users do
    resources :profiles
  end

  match 'home', to: 'pages#home'
  match '',     to: 'users#show', constraints: lambda { |request| request.subdomain.present? && request.subdomain != 'www' }

  root to: 'users#show',          constraints: SignedIn.new(true)
  root to: 'pages#home',          constraints: SignedIn.new(false)
end