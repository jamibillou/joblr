require File.expand_path('../../lib/assets/routes_constraints', __FILE__)

Joblr::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'authentifications', registrations: 'registrations' }

  resources :authentifications, only: [:index, :destroy]
  resources :users do
    resources :profiles
  end

  get 'users/auth/failure'   => 'authentifications#failure'
  match 'users/:id/share'      => 'users#share', as: :user_share
  post 'users/share_profile' => 'users#share_profile'

  match 'home', to: 'pages#home'

  # Subdomain constraints
  match '', to: 'users#show', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' && r.path == '/' }

  root to: 'users#show', constraints: SignedIn.new(true)
  root to: 'pages#home', constraints: SignedIn.new(false)
end