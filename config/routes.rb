require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :users do
    resources :authentifications, only: [:index, :destroy]
    resources :profiles
  end

  root :to => 'users#show', :constraints => SingedIn.new(true)
  root :to => 'pages#home', :constraints => SingedIn.new(false) 
end